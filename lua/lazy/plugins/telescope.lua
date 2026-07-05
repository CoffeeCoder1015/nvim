return { { -- Fuzzy Finder (files, lsp, etc)
    "nvim-telescope/telescope.nvim",
    cond = not vim.g.vscode,
    event = "VimEnter",
    branch = "0.1.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { -- If encountering errors, see telescope-fzf-native README for installation instructions
            "nvim-telescope/telescope-fzf-native.nvim",

            -- `build` is used to run some command when the plugin is installed/updated.
            -- This is only run then, not every time Neovim starts up.
            build = "make",

            -- `cond` is a condition used to determine whether this plugin should be
            -- installed and loaded.
            cond = function()
                return vim.fn.executable("make") == 1
            end,
        },
        { "nvim-telescope/telescope-ui-select.nvim" },
        {
            "stevearc/dressing.nvim",
            lazy = true,
            init = function()
                vim.ui.select = function(...)
                    require("lazy").load({ plugins = { "dressing.nvim" } })
                    return vim.ui.select(...)
                end
                vim.ui.input = function(...)
                    require("lazy").load({ plugins = { "dressing.nvim" } })
                    return vim.ui.input(...)
                end
            end,
        },

        -- Useful for getting pretty icons, but requires a Nerd Font.
        { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
    },
    config = function()
        local root = require("config.root")
        -- Telescope is a fuzzy finder that comes with a lot of different things that
        -- it can fuzzy find! It's more than just a "file finder", it can search
        -- many different aspects of Neovim, your workspace, LSP, and more!
        --
        -- The easiest way to use Telescope, is to start by doing something like:
        --  :Telescope help_tags
        --
        -- After running this command, a window will open up and you're able to
        -- type in the prompt window. You'll see a list of `help_tags` options and
        -- a corresponding preview of the help.
        --
        -- Two important keymaps to use while in Telescope are:
        --  - Insert mode: <c-/>
        --  - Normal mode: ?
        --
        -- This opens a window that shows you all of the keymaps for the current
        -- Telescope picker. This is really useful to discover what Telescope can
        -- do as well as how to actually do it!

        -- [[ Configure Telescope ]]
        -- See `:help telescope` and `:help telescope.setup()`
        local builtin = require("telescope.builtin")
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")

        local function find_command()
            if vim.fn.executable("rg") == 1 then
                return { "rg", "--files", "--color", "never", "-g", "!.git" }
            elseif vim.fn.executable("fd") == 1 then
                return { "fd", "--type", "f", "--color", "never", "-E", ".git" }
            elseif vim.fn.executable("fdfind") == 1 then
                return { "fdfind", "--type", "f", "--color", "never", "-E", ".git" }
            elseif vim.fn.executable("find") == 1 and vim.fn.has("win32") == 0 then
                return { "find", ".", "-type", "f" }
            elseif vim.fn.executable("where") == 1 then
                return { "where", "/r", ".", "*" }
            end
        end

        local function open_with_trouble(...)
            local ok, trouble = pcall(require, "trouble.sources.telescope")
            if ok then
                return trouble.open(...)
            end
        end

        local function find_files(opts)
            opts = opts or {}
            opts.cwd = opts.cwd or root.root()
            builtin.find_files(opts)
        end

        local function live_grep(opts)
            opts = opts or {}
            opts.cwd = opts.cwd or root.root()
            builtin.live_grep(opts)
        end

        local function grep_string(opts)
            opts = opts or {}
            opts.cwd = opts.cwd or root.root()
            builtin.grep_string(opts)
        end

        local function find_files_no_ignore()
            find_files({ no_ignore = true, default_text = action_state.get_current_line() })
        end

        local function find_files_with_hidden()
            find_files({ hidden = true, default_text = action_state.get_current_line() })
        end

        require("telescope").setup({
            defaults = {
                get_selection_window = function()
                    local wins = vim.api.nvim_list_wins()
                    table.insert(wins, 1, vim.api.nvim_get_current_win())
                    for _, win in ipairs(wins) do
                        local buf = vim.api.nvim_win_get_buf(win)
                        if vim.bo[buf].buftype == "" then
                            return win
                        end
                    end
                    return 0
                end,
                mappings = {
                    i = {
                        ["<c-t>"] = open_with_trouble,
                        ["<a-t>"] = open_with_trouble,
                        ["<a-i>"] = find_files_no_ignore,
                        ["<a-h>"] = find_files_with_hidden,
                        ["<C-Down>"] = actions.cycle_history_next,
                        ["<C-Up>"] = actions.cycle_history_prev,
                        ["<C-f>"] = actions.preview_scrolling_down,
                        ["<C-b>"] = actions.preview_scrolling_up,
                    },
                    n = {
                        ["q"] = actions.close,
                    },
                },
            },
            pickers = {
                find_files = {
                    find_command = find_command,
                    hidden = true,
                },
            },
            extensions = {
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown(),
                },
            },
        })

        -- Enable Telescope extensions if they are installed
        pcall(require("telescope").load_extension, "fzf")
        pcall(require("telescope").load_extension, "ui-select")

        -- file
        vim.keymap.set("n", "<leader><space>", find_files, { desc = "Find Files (Root Dir)" })
        vim.keymap.set("n", "<leader>,", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", { desc = "Switch Buffer" })
        vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true ignore_current_buffer=true<cr>", { desc = "Buffers" })
        vim.keymap.set("n", "<leader>fB", builtin.buffers, { desc = "Buffers (all)" })
        vim.keymap.set("n", "<leader>fc", function() find_files({ cwd = vim.fn.stdpath("config") }) end, { desc = "Find Config File" })
        vim.keymap.set("n", "<leader>ff", find_files, { desc = "Find Files (Root Dir)" })
        vim.keymap.set("n", "<leader>fF", builtin.find_files, { desc = "Find Files (cwd)" })
        vim.keymap.set("n", "<leader>fg", builtin.git_files, { desc = "Find Files (git-files)" })
        vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Recent" })
        vim.keymap.set("n", "<leader>fR", function() builtin.oldfiles({ cwd = vim.uv.cwd() }) end, { desc = "Recent (cwd)" })
        vim.keymap.set("n", "<leader>:", builtin.command_history, { desc = "Command History" })

        -- git
        vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "Commits" })
        vim.keymap.set("n", "<leader>gl", function() Snacks.picker.git_log({ cwd = root.git_root() }) end, { desc = "Git Log" })
        vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "Status" })
        vim.keymap.set("n", "<leader>gS", builtin.git_stash, { desc = "Git Stash" })

        -- search
        vim.keymap.set("n", '<leader>s"', builtin.registers, { desc = "Registers" })
        vim.keymap.set("n", "<leader>s/", builtin.search_history, { desc = "Search History" })
        vim.keymap.set("n", "<leader>sa", builtin.autocommands, { desc = "Auto Commands" })
        vim.keymap.set("n", "<leader>sb", builtin.current_buffer_fuzzy_find, { desc = "Buffer Lines" })
        vim.keymap.set("n", "<leader>sc", builtin.command_history, { desc = "Command History" })
        vim.keymap.set("n", "<leader>sC", builtin.commands, { desc = "Commands" })
        vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "Diagnostics" })
        vim.keymap.set("n", "<leader>sD", function() builtin.diagnostics({ bufnr = 0 }) end, { desc = "Buffer Diagnostics" })
        vim.keymap.set("n", "<leader>sf", find_files, { desc = "Files (Root Dir)" })
        vim.keymap.set("n", "<leader>sF", builtin.find_files, { desc = "Files (cwd)" })
        vim.keymap.set("n", "<leader>sg", live_grep, { desc = "Grep (Root Dir)" })
        vim.keymap.set("n", "<leader>sG", builtin.live_grep, { desc = "Grep (cwd)" })
        vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Help Pages" })
        vim.keymap.set("n", "<leader>sH", builtin.highlights, { desc = "Search Highlight Groups" })
        vim.keymap.set("n", "<leader>sj", builtin.jumplist, { desc = "Jumplist" })
        vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "Key Maps" })
        vim.keymap.set("n", "<leader>sl", builtin.loclist, { desc = "Location List" })
        vim.keymap.set("n", "<leader>sM", builtin.man_pages, { desc = "Man Pages" })
        vim.keymap.set("n", "<leader>sm", builtin.marks, { desc = "Jump to Mark" })
        vim.keymap.set("n", "<leader>so", builtin.vim_options, { desc = "Options" })
        vim.keymap.set("n", "<leader>sR", builtin.resume, { desc = "Resume" })
        vim.keymap.set("n", "<leader>sq", builtin.quickfix, { desc = "Quickfix List" })
        vim.keymap.set("n", "<leader>ss", builtin.lsp_document_symbols, { desc = "Goto Symbol" })
        vim.keymap.set("n", "<leader>sS", builtin.lsp_dynamic_workspace_symbols, { desc = "Goto Symbol (Workspace)" })
        vim.keymap.set("n", "<leader>sw", grep_string, { desc = "Word (Root Dir)" })
        vim.keymap.set("n", "<leader>sW", builtin.grep_string, { desc = "Word (cwd)" })
        vim.keymap.set("x", "<leader>sw", grep_string, { desc = "Selection (Root Dir)" })
        vim.keymap.set("x", "<leader>sW", builtin.grep_string, { desc = "Selection (cwd)" })
        vim.keymap.set("n", "<leader>uC", function() builtin.colorscheme({ enable_preview = true }) end, { desc = "Colorscheme with Preview" })

        vim.keymap.set("n", "<leader>/", function()
            live_grep()
        end, { desc = "Grep (Root Dir)" })
    end,
} }
