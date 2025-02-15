local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = {
		-- add LazyVim and import its plugins
		{
			"LazyVim/LazyVim",
			import = "lazyvim.plugins",
			opts = {
				colorscheme = "tokyonight-night",
				defaults = {},
			},
		},
		{
			"tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically

			-- "gc" to comment visual regions/lines
			{ "numToStr/Comment.nvim", opts = {} },

			{ -- Adds git related signs to the gutter, as well as utilities for managing changes
				"lewis6991/gitsigns.nvim",
				opts = {
					signs = {
						add = { text = "+" },
						change = { text = "~" },
						delete = { text = "_" },
						topdelete = { text = "‾" },
						changedelete = { text = "~" },
					},
				},
			},

			{ -- You can easily change to a different colorscheme.
				-- Change the name of the colorscheme plugin below, and then
				-- change the command in the config to whatever the name of that colorscheme is.
				--
				-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
				"folke/tokyonight.nvim",
				priority = 1000, -- Make sure to load this before all the other start plugins.
				init = function()
					-- Load the colorscheme here.
					-- Like many other themes, this one has different styles, and you could load
					-- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
					vim.cmd.colorscheme("tokyonight-night")

					-- You can configure highlights by doing something like:
					vim.cmd.hi("Comment gui=none")
				end,
			},

			-- Highlight todo, notes, etc in comments
			{
				"folke/todo-comments.nvim",
				event = "VimEnter",
				dependencies = { "nvim-lua/plenary.nvim" },
				opts = { signs = false },
				vscode = true,
			},

			{ -- Collection of various small independent plugins/modules
				"echasnovski/mini.nvim",
				vscode = true,
				config = function()
					-- Better Around/Inside textobjects
					--
					-- Examples:
					--  - va)  - [V]isually select [A]round [)]paren
					--  - yinq - [Y]ank [I]nside [N]ext [']quote
					--  - ci'  - [C]hange [I]nside [']quote
					require("mini.ai").setup({ n_lines = 500 })

					-- Add/delete/replace surroundings (brackets, quotes, etc.)
					--
					-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
					-- - sd'   - [S]urround [D]elete [']quotes
					-- - sr)'  - [S]urround [R]eplace [)] [']
					require("mini.surround").setup({
						vscode = true;
					})

					-- Simple and easy statusline.
					--  You could remove this setup call if you don't like it,
					--  and try some other statusline plugin
					local statusline = require("mini.statusline")
					-- set use_icons to true if you have a Nerd Font
					statusline.setup({ use_icons = vim.g.have_nerd_font })

					-- You can configure sections in the statusline by overriding their
					-- default behavior. For example, here we set the section for
					-- cursor location to LINE:COLUMN
					---@diagnostic disable-next-line: duplicate-set-field
					statusline.section_location = function()
						return "%2l:%-2v"
					end

					-- ... and there is more!
					--  Check out: https://github.com/echasnovski/mini.nvim
				end,
			},
		},
		-- import/override with your plugins
		{ import = "lazy.plugins" },
		{ import = "lazy.qol" },
	},
	defaults = {
		-- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
		-- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
		lazy = false,
		-- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
		-- have outdated releases, which may break your Neovim install.
		version = false, -- always use the latest git commit
		-- version = "*", -- try installing the latest stable version for plugins that support semver
	},
	install = {
		--  colorscheme = { "tokyonight", "habamax" }
	},
	checker = {
		enabled = true, -- check for plugin updates periodically
		notify = false, -- notify on update
	}, -- automatically check for plugin updates
	performance = {
		rtp = {
			-- disable some rtp plugins
			disabled_plugins = {
				-- "gzip",
				-- -- "matchit",
				-- -- "matchparen",
				-- -- "netrwPlugin",
				-- "tarPlugin",
				-- "tohtml",
				-- "tutor",
				-- "zipPlugin",
			},
		},
	},
})
