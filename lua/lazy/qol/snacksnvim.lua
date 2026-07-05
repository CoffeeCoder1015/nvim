-- Terminal Mappings
local function term_nav(dir)
  ---@param self snacks.terminal
  return function(self)
    return self:is_floating() and "<c-" .. dir .. ">" or vim.schedule(function()
      vim.cmd.wincmd(dir)
    end)
  end
end

local indent_exclude = {
  Trouble = true,
  alpha = true,
  dashboard = true,
  help = true,
  lazy = true,
  mason = true,
  ["neo-tree"] = true,
  notify = true,
  snacks_dashboard = true,
  snacks_notif = true,
  snacks_terminal = true,
  snacks_win = true,
  toggleterm = true,
  trouble = true,
}

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    dashboard = {
      preset = {
        header = [[
          __|__ |___| |\                                   
          |o__| |___| | \                                  
          |___| |___| |o \                                 
         _|___| |___| |__o\                                
        /...\_____|___|____\_/                             
        \   o * o * * o o  /                               
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
███████╗ █████╗ ██╗██╗          █████╗  ██████╗  █████╗ ██╗███╗   ██║
██╔════╝██╔══██╗██║██║         ██╔══██╗██╔════╝ ██╔══██╗██║████╗  ██║
███████╗███████║██║██║         ███████║██║  ███╗███████║██║██╔██╗ ██║
╚════██║██╔══██║██║██║         ██╔══██║██║   ██║██╔══██║██║██║╚██╗██║
███████║██║  ██║██║███████╗    ██║  ██║╚██████╔╝██║  ██║██║██║ ╚████║
╚══════╝╚═╝  ╚═╝╚═╝╚══════╝    ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝
]],
      },
      formats = {
        key = function(item)
          return { { "[", hl = "special" }, { item.key, hl = "key" }, { "]", hl = "special" } }
        end,
      },
      sections = {
        { section = "header" },
        { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = { 2, 0 } },
        { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 2 },
        { section = "keys", gap = 1, padding = { 2, 0 } },
        { section = "startup" },
      },
    },
    indent = {
      enabled = true,
      filter = function(buf)
        return vim.g.snacks_indent ~= false
          and vim.b[buf].snacks_indent ~= false
          and vim.bo[buf].buftype == ""
          and not indent_exclude[vim.bo[buf].filetype]
      end,
    },
    input = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = false },
    statuscolumn = { enabled = false },
    words = { enabled = true },
    terminal = {
      win = {
        keys = {
          nav_h = { "<C-h>", term_nav("h"), desc = "Go to Left Window", expr = true, mode = "t" },
          nav_j = { "<C-j>", term_nav("j"), desc = "Go to Lower Window", expr = true, mode = "t" },
          nav_k = { "<C-k>", term_nav("k"), desc = "Go to Upper Window", expr = true, mode = "t" },
          nav_l = { "<C-l>", term_nav("l"), desc = "Go to Right Window", expr = true, mode = "t" },
          hide_slash = { "<C-/>", "hide", desc = "Hide Terminal", mode = "t" },
          hide_underscore = { "<c-_>", "hide", desc = "which_key_ignore", mode = "t" },
        },
      },
    },
  },
  keys = {
    { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
    { "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
    { "<leader>n", function() Snacks.notifier.show_history() end, desc = "Notification History" },
    { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
  },
}
