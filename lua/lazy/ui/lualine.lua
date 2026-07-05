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

    local function pretty_path()
      local path = vim.fn.expand("%:p")
      if path == "" then
        return ""
      end
      local root = require("config.root").root()
      if root and path:find(root, 1, true) == 1 then
        path = path:sub(#root + 2)
      else
        path = vim.fn.fnamemodify(path, ":~:.")
      end
      return path .. (vim.bo.modified and " [+]" or "")
    end

    local function macro_recording()
      local register = vim.fn.reg_recording()
      if register == "" then
        return ""
      end
      return "recording @" .. register
    end

    local function dap_status()
      if not package.loaded["dap"] then
        return ""
      end
      local status = require("dap").status()
      return status ~= "" and ("DAP: " .. status) or ""
    end

    local function noice_status(kind, field)
      return {
        function()
          return require("noice").api.status[kind][field]()
        end,
        cond = function()
          return package.loaded["noice"] and require("noice").api.status[kind].has()
        end,
      }
    end

    local function lazy_updates()
      local ok, status = pcall(require, "lazy.status")
      if not ok then
        return { function() return "" end, cond = function() return false end }
      end
      return {
        status.updates,
        cond = status.has_updates,
      }
    end

    local function git_diff()
      return {
        "diff",
        source = function()
          local gitsigns = vim.b.gitsigns_status_dict
          if gitsigns then
            return {
              added = gitsigns.added,
              modified = gitsigns.changed,
              removed = gitsigns.removed,
            }
          end
        end,
      }
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
          pretty_path,
        },
        lualine_x = {
          noice_status("command", "get"),
          noice_status("mode", "get"),
          lazy_updates(),
          git_diff(),
          dap_status,
          macro_recording,
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      extensions = { "neo-tree", "lazy" },
    }
  end,
  config = function(_, opts)
    if vim.g.trouble_lualine then
      local ok, trouble = pcall(require, "trouble")
      if ok then
        local symbols = trouble.statusline({
          mode = "symbols",
          groups = {},
          title = false,
          filter = { range = true },
          format = "{kind_icon}{symbol.name:Normal}",
          hl_group = "lualine_c_normal",
        })
        table.insert(opts.sections.lualine_c, {
          symbols.get,
          cond = function()
            return vim.b.trouble_lualine ~= false and symbols.has()
          end,
        })
      end
    end

    require("lualine").setup(opts)
    vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave" }, {
      group = vim.api.nvim_create_augroup("lualine_macro_recording", { clear = true }),
      callback = function()
        require("lualine").refresh({ place = { "statusline" } })
      end,
    })
  end,
}
