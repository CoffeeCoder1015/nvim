-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- map for going into netrw
vim.keymap.set("n", "<leader>nrw", vim.cmd.Ex, { desc = "open up netrw" })

-- yank into system
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank selection into OS clipboard" })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "Yank current line to OS clipbord" })

-- show notif history
vim.keymap.set({ "n", "v" }, "<leader>sNh", function()
	Snacks.notifier.show_history()
end, { desc = "show notification history" })

-- Calculator
-- original_expression -> original_expression = answer
vim.keymap.set("v", "<leader>cc", function()
	-- 1. Get visual selection start/end
	local s_pos = vim.fn.getpos("'<") -- start of visual selection
	local e_pos = vim.fn.getpos("'>") -- end of visual selection

	-- 2. Convert to 0-based
	local bufnr = vim.api.nvim_get_current_buf()
	local start_row = s_pos[2] - 1
	local start_col = s_pos[3] - 1
	local end_row = e_pos[2] - 1
	local end_col = e_pos[3]

	-- 3. Fetch lines in range
	local lines = vim.api.nvim_buf_get_lines(bufnr, start_row, end_row + 1, false)

	-- 4. Trim first/last lines to selection columns
	if #lines == 1 then
		lines[1] = lines[1]:sub(start_col + 1, end_col)
	else
		lines[1] = lines[1]:sub(start_col + 1)
		lines[#lines] = lines[#lines]:sub(1, end_col)
	end

	-- 5. Join into one expression string
	local expr = table.concat(lines, "\n")

	-- 6. Safely evaluate
	local ok, result = pcall(vim.fn.eval, expr)
	if not ok then
		result = "ERROR"
	end

	-- 7. Prepare replacement
	local replacement = string.format("%s = %s", expr, result)

	-- 8. Replace the selected lines
	vim.api.nvim_buf_set_lines(bufnr, start_row, end_row + 1, false, { replacement })
end, { desc = "Evaluate visual selection as math", noremap = true })
