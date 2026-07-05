--------------------------
-- Custom nvim configs --
-------------------------
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Snacks animations
vim.g.snacks_animate = true

-- Hide deprecation warnings
vim.g.deprecation_warnings = false

-- Show the current document symbols location from Trouble in lualine
vim.g.trouble_lualine = true

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

local opt = vim.opt

-- 4 space indent (user preference, LazyVim default is 2)
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

-- Prefer PowerShell Core on Windows when installed; otherwise use Windows PowerShell.
if vim.fn.has("win32") == 1 then
  opt.shell = vim.fn.exepath("pwsh.exe")
  if opt.shell:get() == "" then
    opt.shell = vim.fn.exepath("powershell.exe")
  end
  opt.shellcmdflag = "-NoLogo -ExecutionPolicy RemoteSigned -Command"
  opt.shellredir = "2>&1 | Out-File %s; exit $LastExitCode"
  opt.shellpipe = "2>&1 | tee %s; exit $LastExitCode"
  opt.shellquote = ""
  opt.shellxquote = ""
end

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = false

-- LazyVim options
opt.autowrite = true
opt.clipboard = ""
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 2
opt.confirm = true
opt.cursorline = true
opt.fillchars = {
  foldopen = "v",
  foldclose = ">",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
opt.foldlevel = 99
opt.foldmethod = "indent"
opt.foldtext = ""
opt.formatoptions = "jcroqlnt"
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true
opt.inccommand = "nosplit"
opt.jumpoptions = "view"
opt.laststatus = 3 -- global statusline
opt.linebreak = true
opt.list = true
opt.listchars = { tab = "  ", trail = "·", nbsp = "␣" }
opt.mouse = "a"
opt.number = true
opt.pumblend = 10
opt.pumheight = 10
opt.relativenumber = true
opt.ruler = false
opt.scrolloff = 10
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.shiftround = true
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.showmode = false
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.smartcase = true
opt.smartindent = true
opt.smoothscroll = true
opt.spelllang = { "en" }
opt.splitbelow = true
opt.splitkeep = "screen"
opt.splitright = true
opt.termguicolors = true
opt.timeoutlen = vim.g.vscode and 1000 or 300
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200
opt.virtualedit = "block"
opt.wildmode = "longest:full,full"
opt.winminwidth = 5
opt.wrap = false

-- Enable break indent
opt.breakindent = true

-- Project roots are handled explicitly by config.root.
opt.autochdir = false
