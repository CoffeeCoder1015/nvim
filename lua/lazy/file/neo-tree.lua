-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  cond = not vim.g.vscode,
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    {
      '\\',
      function()
        require("neo-tree.command").execute({
          action = "focus",
          reveal = true,
          dir = require("config.root").root(),
        })
      end,
      desc = 'NeoTree reveal',
    },
  },
  opts = {
    filesystem = {
      bind_to_cwd = false,
      follow_current_file = { enabled = true },
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },
  },
}
