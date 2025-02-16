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
		},
		-- import/override with your plugins
		{ import = "lazy.plugins" },
		{ import = "lazy.qol" },
		{ import = "lazy.file" },
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
