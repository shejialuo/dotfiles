return {
  -- "stevearc/conform.nvim"
  -- This is a general purpose code formatter, we enable it to format code
  -- on save and also provide a keymap to manually format code.
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({
            async = true,
            lsp_format = "fallback"
          })
        end,
        mode = { "n", "v" },
        desc = "Format",
      },
    },
    opts = {
      formatters_by_ft = {
        python = { "isort", "black" },
        rust = { "rustfmt" },
      },

      default_format_opts = {
        lsp_format = "fallback",
      },

      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
    },
  },
}
