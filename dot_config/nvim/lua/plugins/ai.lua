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
    end,
    keys = {
      { "<leader>uz", "<cmd>Codeium Toggle<cr>", desc = "Toggle WindSurf"  }
    }
  },
  {
    "olimorris/codecompanion.nvim",
    keys = {
      {
        "<leader>aa", "<cmd>CodeCompanionActions<cr>",
        mode = { "n", "v" }, desc = "CodeCompanion Actions",
      },
      {
        "<leader>an", "<cmd>CodeCompanionChat<cr>",
        mode = { "n", "v" }, desc = "CodeCompanion New Chat",
      },
      {
        "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>",
        mode = { "n", "v" }, desc = "CodeCompanion Toggle",
      },
    },
    opts = {
      display = {
        provider = "snacks",
      },
      adapters = {
        http = {
          opts = {
            show_presets = false,
          }
        },
        acp = {
          codex = function()
            return require("codecompanion.adapters").extend("codex", {
              defaults = {
                auth_method = "chatgpt"
              },
            })
          end,
          opts = {
            show_presets = false,
          },
        }
      },
      interactions = {
        chat = {
          adapter = "codex",
        },
        cli = {
          agent = "codex",
          agents = {
            codex = {
              cmd = "codex",
              args = {},
              description = "codex CLI",
              provider = "terminal",
            }
          },
        },
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    }
  }
}
