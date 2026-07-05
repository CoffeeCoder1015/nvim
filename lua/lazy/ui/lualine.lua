return {
  "nvim-lualine/lualine.nvim",
  cond = not vim.g.vscode,
  event = "VeryLazy",
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      vim.o.statusline = " "
    else
      vim.o.laststatus = 0
    end
  end,
  opts = function()
    local function root_dir()
      local root = require("config.root").root()
      if not root then
        return ""
      end
      return vim.fn.fnamemodify(root, ":t")
    end

    local function macro_recording()
      local register = vim.fn.reg_recording()
      if register == "" then
        return ""
      end
      return "recording @" .. register
    end

    return {
      options = {
        theme = "auto",
        globalstatus = vim.o.laststatus == 3,
        disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter" } },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = {
          root_dir,
          {
            "diagnostics",
            symbols = {
              error = " ",
              warn  = " ",
              info  = " ",
              hint  = " ",
            },
          },
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          { "filename", path = 1 },
        },
        lualine_x = {
          macro_recording,
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      extensions = { "neo-tree", "lazy" },
    }
  end,
  config = function(_, opts)
    require("lualine").setup(opts)
    vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave" }, {
      group = vim.api.nvim_create_augroup("lualine_macro_recording", { clear = true }),
      callback = function()
        require("lualine").refresh({ place = { "statusline" } })
      end,
    })
  end,
}
