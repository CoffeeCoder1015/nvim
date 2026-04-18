return {
  {
    "stevearc/conform.nvim",
    dependencies = { "mason.nvim" },
    lazy = true,
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>cF",
        function()
          require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
        end,
        mode = { "n", "x" },
        desc = "Format Injected Langs",
      },
      {
        "<leader>cf",
        function()
          require("conform").format({ timeout_ms = 3000, lsp_format = "fallback" })
        end,
        mode = { "n", "x" },
        desc = "Format Buffer",
      },
    },
    opts = {
      default_format_opts = {
        timeout_ms = 3000,
        async = false,
        quiet = false,
        lsp_format = "fallback",
      },
      formatters_by_ft = {
        lua = { "stylua" },
        fish = { "fish_indent" },
        sh = { "shfmt" },
      },
      formatters = {
        injected = { options = { ignore_errors = true } },
      },
    },
    init = function()
      -- Format on save
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("conform-format-on-save", { clear = true }),
        callback = function(args)
          require("conform").format({ bufnr = args.buf, timeout_ms = 3000, lsp_format = "fallback" })
        end,
      })
    end,
  },
}
