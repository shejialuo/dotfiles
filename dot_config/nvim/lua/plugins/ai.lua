return {
  {
    "Exafunction/windsurf.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("codeium").setup({
        enable_cmp_source = false,
        enable_chat = true,
        virtual_text = {
          enabled = true,
          manual = false,
          key_bindings = {
            -- Accept the current completion.
            accept = "<C-y>",
            -- Accept the next word.
            accept_word = false,
            -- Accept the next line.
            accept_line = false,
            -- Clear the virtual text.
            clear = false,
            -- Cycle to the next completion.
            next = "<M-]>",
            -- Cycle to the previous completion.
            prev = "<M-[>",
          }
        },
      })
    end
  }
}
