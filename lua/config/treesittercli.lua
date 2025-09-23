local fn = vim.fn
local uv = vim.loop

local function cli_exists()
  return fn.executable("tree-sitter") == 1
end

local function install_cli()
  if cli_exists() then
    return
  end

  print("tree-sitter CLI not found, installing...")

  -- Try cargo first
  -- Then npm
  if fn.executable("npm") == 1 then
    local ok = fn.system("npm install -g tree-sitter-cli")
    print("ok")
  elseif fn.executable("cargo") == 1 then
      local ok = fn.system("cargo install --locked tree-sitter-cli")
      print("ok")
  else
    print("Error: Neither cargo nor npm is installed. Please install one to proceed.")
  end

  -- Confirm installation
  if cli_exists() then
    print("tree-sitter CLI installed successfully!")
  else
    print("tree-sitter CLI installation failed.")
  end
end

return install_cli