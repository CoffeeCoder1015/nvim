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
          require("config.format").format({ force = true })
        end,
        mode = { "n", "x" },
        desc = "Format Buffer",
      },
    },
    config = function(_, opts)
      require("conform").setup(opts)
    end,
    opts = {
      default_format_opts = {
        timeout_ms = 3000,
        async = false,
        quiet = false,
        lsp_format = "fallback",
      },
      formatters_by_ft = {
        lua = { "stylua" },
        go = { "goimports", "gofumpt" },
        fish = { "fish_indent" },
        sh = { "shfmt" },
      },
      formatters = {
        injected = { options = { ignore_errors = true } },
      },
    },
    init = function()
      require("config.format").setup()
    end,
  },
}
