local M = {}

local function supports(client, method, bufnr)
	if not client then
		return false
	end

	method = method:find("/", 1, true) and method or ("textDocument/" .. method)
	if client.supports_method then
		return client:supports_method(method, bufnr)
	end

	local capability = {
		["textDocument/codeAction"] = "codeActionProvider",
		["textDocument/codeLens"] = "codeLensProvider",
		["textDocument/declaration"] = "declarationProvider",
		["textDocument/definition"] = "definitionProvider",
		["textDocument/documentHighlight"] = "documentHighlightProvider",
		["textDocument/foldingRange"] = "foldingRangeProvider",
		["textDocument/hover"] = "hoverProvider",
		["textDocument/implementation"] = "implementationProvider",
		["textDocument/inlayHint"] = "inlayHintProvider",
		["textDocument/references"] = "referencesProvider",
		["textDocument/rename"] = "renameProvider",
		["textDocument/signatureHelp"] = "signatureHelpProvider",
		["textDocument/typeDefinition"] = "typeDefinitionProvider",
	}
	return vim.tbl_get(client.server_capabilities or {}, capability[method] or "") ~= nil
end

local function action(kind)
	return function()
		vim.lsp.buf.code_action({
			apply = true,
			context = {
				only = { kind },
				diagnostics = {},
			},
		})
	end
end

local function rename_file()
	if Snacks and Snacks.rename and Snacks.rename.rename_file then
		return Snacks.rename.rename_file()
	end
	local ok, rename = pcall(require, "snacks.rename")
	if ok and rename.rename_file then
		return rename.rename_file()
	end
	vim.notify("snacks.rename is not available", vim.log.levels.WARN)
end

function M.setup()
	vim.diagnostic.config({
		underline = true,
		update_in_insert = false,
		virtual_text = {
			spacing = 4,
			source = "if_many",
			prefix = "*",
		},
		severity_sort = true,
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = "E",
				[vim.diagnostic.severity.WARN] = "W",
				[vim.diagnostic.severity.HINT] = "H",
				[vim.diagnostic.severity.INFO] = "I",
			},
		},
	})
end

function M.capabilities(capabilities)
	capabilities.workspace = vim.tbl_deep_extend("force", capabilities.workspace or {}, {
		fileOperations = {
			didRename = true,
			willRename = true,
		},
	})
	return capabilities
end

function M.on_attach(event)
	local client = vim.lsp.get_client_by_id(event.data.client_id)
	local bufnr = event.buf
	local telescope = require("telescope.builtin")

	local function map(mode, keys, rhs, desc, has)
		if has and not supports(client, has, bufnr) then
			return
		end
		vim.keymap.set(mode, keys, rhs, { buffer = bufnr, desc = "LSP: " .. desc })
	end

	map("n", "<leader>cl", "<cmd>LspInfo<cr>", "Info")
	map("n", "gd", telescope.lsp_definitions, "Goto Definition", "definition")
	map("n", "gr", telescope.lsp_references, "References", "references")
	map("n", "gI", telescope.lsp_implementations, "Goto Implementation", "implementation")
	map("n", "gy", telescope.lsp_type_definitions, "Goto Type Definition", "typeDefinition")
	map("n", "<leader>D", telescope.lsp_type_definitions, "Type Definition", "typeDefinition")
	map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration", "declaration")
	map("n", "K", vim.lsp.buf.hover, "Hover", "hover")
	map("n", "gh", vim.lsp.buf.hover, "Hover", "hover")
	map("n", "gK", vim.lsp.buf.signature_help, "Signature Help", "signatureHelp")
	map("i", "<c-k>", vim.lsp.buf.signature_help, "Signature Help", "signatureHelp")
	map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Code Action", "codeAction")
	map("n", "<leader>cA", action("source"), "Source Action", "codeAction")
	map("n", "<leader>co", action("source.organizeImports"), "Organize Imports", "codeAction")
	if vim.lsp.codelens then
		map({ "n", "x" }, "<leader>cc", vim.lsp.codelens.run, "Run Codelens", "codeLens")
		map("n", "<leader>cC", vim.lsp.codelens.refresh, "Refresh Codelens", "codeLens")
	end
	map("n", "<leader>cR", rename_file, "Rename File", "workspace/didRenameFiles")
	map("n", "<leader>cr", vim.lsp.buf.rename, "Rename", "rename")
	map("n", "<leader>rn", vim.lsp.buf.rename, "Rename", "rename")
	map("n", "<leader>ds", telescope.lsp_document_symbols, "Document Symbols", "documentSymbol")
	map("n", "<leader>ws", telescope.lsp_dynamic_workspace_symbols, "Workspace Symbols", "workspace/symbol")

	if supports(client, "documentHighlight", bufnr) then
		local highlight_augroup = vim.api.nvim_create_augroup("config-lsp-highlight", { clear = false })
		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			buffer = bufnr,
			group = highlight_augroup,
			callback = vim.lsp.buf.document_highlight,
		})
		vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
			buffer = bufnr,
			group = highlight_augroup,
			callback = vim.lsp.buf.clear_references,
		})
		vim.api.nvim_create_autocmd("LspDetach", {
			group = vim.api.nvim_create_augroup("config-lsp-detach", { clear = true }),
			callback = function(event2)
				vim.lsp.buf.clear_references()
				vim.api.nvim_clear_autocmds({ group = highlight_augroup, buffer = event2.buf })
			end,
		})
	end

	if supports(client, "inlayHint", bufnr) and vim.lsp.inlay_hint then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end

	if supports(client, "foldingRange", bufnr) and vim.lsp.foldexpr then
		vim.wo.foldmethod = "expr"
		vim.wo.foldexpr = "v:lua.vim.lsp.foldexpr()"
	end

	if supports(client, "codeLens", bufnr) and vim.lsp.codelens then
		vim.lsp.codelens.refresh({ bufnr = bufnr })
		vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
			buffer = bufnr,
			callback = function()
				vim.lsp.codelens.refresh({ bufnr = bufnr })
			end,
		})
	end
end

return M
