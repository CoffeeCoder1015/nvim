return {
	"vscode-neovim/vscode-multi-cursor.nvim",
	event = "verylazy",
	vscode = true,
	cond = not not vim.g.vscode,
	opts = {},
}

