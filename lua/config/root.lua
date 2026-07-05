local M = {}

M.markers = {
  ".git",
  "lua",
  "package.json",
  "Cargo.toml",
  "go.mod",
  "pyproject.toml",
  "Makefile",
}

local function realpath(path)
  if not path or path == "" then
    return nil
  end
  return vim.uv.fs_realpath(path) or path
end

local function bufpath(buf)
  buf = buf or 0
  local name = vim.api.nvim_buf_get_name(buf)
  if name == "" then
    return nil
  end
  return realpath(name)
end

local function dirname(path)
  if not path or path == "" then
    return nil
  end
  local stat = vim.uv.fs_stat(path)
  if stat and stat.type == "directory" then
    return path
  end
  return vim.fs.dirname(path)
end

function M.lsp(buf)
  buf = buf or 0
  local clients = vim.lsp.get_clients({ bufnr = buf })
  for _, client in ipairs(clients) do
    local root_dir = client.config and client.config.root_dir
    if root_dir and root_dir ~= "" then
      return realpath(root_dir)
    end

    local folders = client.workspace_folders
    if folders and folders[1] and folders[1].name then
      return realpath(folders[1].name)
    end
  end
end

function M.marker(buf)
  local path = bufpath(buf) or vim.uv.cwd()
  local start = dirname(path) or vim.uv.cwd()
  local found = vim.fs.find(M.markers, { path = start, upward = true })[1]
  if not found then
    return nil
  end
  if vim.fs.basename(found) == ".git" then
    return realpath(vim.fs.dirname(found))
  end
  return realpath(vim.fs.dirname(found))
end

function M.root(buf)
  return M.lsp(buf) or M.marker(buf) or realpath(vim.uv.cwd())
end

function M.git_root(buf)
  local path = bufpath(buf) or vim.uv.cwd()
  local start = dirname(path) or vim.uv.cwd()
  local git = vim.fs.find(".git", { path = start, upward = true })[1]
  if git then
    return realpath(vim.fs.dirname(git))
  end
  return M.root(buf)
end

function M.chdir(buf)
  local root = M.root(buf)
  if root then
    vim.cmd.tcd(vim.fn.fnameescape(root))
  end
  return root
end

function M.setup()
  vim.api.nvim_create_user_command("NvimRoot", function()
    local root = M.chdir(0)
    if root then
      vim.notify("Root: " .. root)
    end
  end, { desc = "Switch tab cwd to detected project root" })
end

return M
