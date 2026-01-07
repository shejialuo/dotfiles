return {
  -- "nvim-mini/mini.pairs"
  -- To make life easier with automatically pairing
  {
    "nvim-mini/mini.pairs",
    version = "*",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      modes = { insert = true, command = true, terminal = false },
      -- For simplicity, we would just disable "`" as it is bad
      -- for markdown file.
      mappings = {
        ["`"] = false,
      }
    },
    config = function(_, opts)
      require("mini.pairs").setup(opts)
      -- Allow "<C-h>" to use "mini.pairs"
      vim.keymap.set("i", "<C-h>", "v:lua.MiniPairs.bs()",
                     { expr = true, replace_keycodes = false })
    end,
  },
  -- "nvim-mini/mini.ai"
  -- This plugin is used to enhance the textobject of neovim
  -- Besides the common textobject `", <, [`. Sometimes, we want more semantic
  -- textobject like functions, classes and code blocks.
  -- With "nvim-treesitter", we could make this become true with this plugin.
  -- The most exciting thing is that "mini.ai" supports count like
  -- "v2af" "c2af"
  {
    "nvim-mini/mini.ai",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter"
    },
    opts = function()
      local ai = require("mini.ai")
      return {
        o = ai.gen_spec.treesitter({ -- code block
          a = { "@block.outer", "@conditional.outer", "@loop.outer" },
          i = { "@block.inner", "@conditional.inner", "@loop.inner" },
        }),
        f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
        c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
      }
    end,
  },
  -- "saghen/blink.cmp"
  -- This plugin is used for auto completion.
  {
    "saghen/blink.cmp",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    version = "*",
    opts = {
      keymap = {
        preset = "default",
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = {
          function(cmp)
            if cmp.snippet_active() then
              return cmp.snippet_forward()
            else
              return cmp.select_next()
            end
          end,
          "fallback"
        },
        ["<S-Tab>"] = {
          function(cmp)
            if cmp.snippet_active() then
              return cmp.snippet_backward()
            else
              return cmp.select_prev()
            end
          end,
          "fallback"
        },
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<C-Space>"] = { "show", "show_documentation", "hide_documentation", "fallback" },
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      },
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 500
        }
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer"},
      },
    },
    opts_extend = { "sources.default" }
  },
  -- "smjonas/inc-rename.nvim"
  -- This plugin is used to enhance LSP rename(refactor) functionality
  {
    "smjonas/inc-rename.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      input_buffer_type = "snacks",
    },
  }
}
