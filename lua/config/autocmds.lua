-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Example autocmd that says ello whenever a new buffer is added
-- vim.api.nvim_create_autocmd({ "BufAdd" }, {
-- 	desc = "Say hello when opening a file",
-- 	group = vim.api.nvim_create_augroup("Test", { clear = true }),
-- 	callback = function()
-- 		print("ello")
-- 	end,
-- })
--
