-- Custom configurations for neovim
-- Load options first (before plugins, so mapleader is set correctly)
require("config.options")

-- Bootstrap lazy.nvim and load plugins
require("lazy.lazy")

-- Load keymaps and autocmds after plugins
require("config.keymaps")
require("config.autocmds")
