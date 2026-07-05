local M = {}

local function conform()
	return require("conform")
end

function M.enabled(buf)
	buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
	if vim.b[buf].autoformat ~= nil then
		return vim.b[buf].autoformat
	end
	return vim.g.autoformat == nil or vim.g.autoformat
end

function M.enable(enable, buf)
	if enable == nil then
		enable = true
	end
	if buf then
		vim.b.autoformat = enable
	else
		vim.g.autoformat = enable
		vim.b.autoformat = nil
	end
	M.info()
end

function M.toggle(buf)
	M.enable(not M.enabled(), buf)
end

function M.format(opts)
	opts = opts or {}
	local bufnr = opts.buf or vim.api.nvim_get_current_buf()
	if not (opts.force or M.enabled(bufnr)) then
		return
	end
	conform().format(vim.tbl_deep_extend("force", {
		bufnr = bufnr,
		timeout_ms = 3000,
		lsp_format = "fallback",
	}, opts))
end

function M.info(buf)
	buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
	local global = vim.g.autoformat == nil or vim.g.autoformat
	local local_value = vim.b[buf].autoformat
	local local_text = local_value == nil and "inherit" or (local_value and "enabled" or "disabled")
	local enabled = M.enabled(buf)
	local lines = {
		("Autoformat: %s"):format(enabled and "enabled" or "disabled"),
		("Global: %s"):format(global and "enabled" or "disabled"),
		("Buffer: %s"):format(local_text),
	}

	local ok, list = pcall(function()
		return conform().list_formatters(buf)
	end)
	if ok and #list > 0 then
		lines[#lines + 1] = ""
		lines[#lines + 1] = "Formatters:"
		for _, formatter in ipairs(list) do
			lines[#lines + 1] = "- " .. formatter.name
		end
	else
		lines[#lines + 1] = ""
		lines[#lines + 1] = "No formatters available for this buffer."
	end

	vim.notify(table.concat(lines, "\n"), enabled and vim.log.levels.INFO or vim.log.levels.WARN, {
		title = "LazyFormat",
	})
end

function M.formatexpr()
	return conform().formatexpr()
end

function M.setup()
	vim.g.autoformat = vim.g.autoformat == nil and true or vim.g.autoformat
	vim.o.formatexpr = "v:lua.require'config.format'.formatexpr()"

	vim.api.nvim_create_autocmd("BufWritePre", {
		group = vim.api.nvim_create_augroup("LazyFormat", { clear = true }),
		callback = function(event)
			M.format({ buf = event.buf })
		end,
	})

	vim.api.nvim_create_user_command("LazyFormat", function()
		M.format({ force = true })
	end, { desc = "Format selection or buffer" })

	vim.api.nvim_create_user_command("LazyFormatInfo", function()
		M.info()
	end, { desc = "Show formatters for the current buffer" })
end

function M.snacks_toggle(buf)
	return Snacks.toggle({
		name = "Auto Format (" .. (buf and "Buffer" or "Global") .. ")",
		get = function()
			if buf then
				return M.enabled()
			end
			return vim.g.autoformat == nil or vim.g.autoformat
		end,
		set = function(state)
			M.enable(state, buf)
		end,
	})
end

return M
