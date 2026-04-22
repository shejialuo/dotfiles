return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "codecompanion" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("render-markdown").setup({
        heading = {
          enabled = true,
          position = "inline",
          icons = { "󰎥 ", "󰎨 ", "󰎫 ", "󰎲 ", "󰎯 ", "󰎴 " },
          backgrounds = {},
        },
        code = {
          enabled = true,
          highlight_border = false,
          style = "language",
        },
        bullet = {
          ordered_icons = function(ctx)
            return vim.trim(ctx.value)
          end,
        }
      })

    vim.api.nvim_set_hl(0, "RenderMarkdownH1Bg", { link = "@markup.heading.1.markdown" })
    vim.api.nvim_set_hl(0, "RenderMarkdownH2Bg", { link = "@markup.heading.2.markdown" })
    vim.api.nvim_set_hl(0, "RenderMarkdownH3Bg", { link = "@markup.heading.3.markdown" })
    vim.api.nvim_set_hl(0, "RenderMarkdownH4Bg", { link = "@markup.heading.4.markdown" })
    vim.api.nvim_set_hl(0, "RenderMarkdownH5Bg", { link = "@markup.heading.5.markdown" })
    vim.api.nvim_set_hl(0, "RenderMarkdownH6Bg", { link = "@markup.heading.6.markdown" })
    vim.api.nvim_set_hl(0, "RenderMarkdownBullet", { link = "@markup.list" })
    end,
  },
  {
    "zk-org/zk-nvim",
    ft = "markdown",
    config = function()
      require("zk").setup({
        lsp = {
          auto_attach = {
            enabled = true,
            filetypes = { "markdown" },
          },
        },
      })
      vim.keymap.set("n", "<leader>zn",
                     "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>",
                     { noremap = true, silent = true, desc = "New Note(zk)" })
      vim.keymap.set("n", "<leader>zf",
                     "<Cmd>ZkNotes { sort = { 'modified' } }<CR>",
                     { noremap = true, silent = true, desc = "Find Notes(zk)" })
      vim.keymap.set("n", "<leader>zb", "<Cmd>ZkBacklinks<CR>",
                     { noremap = true, silent = true, desc = "Backlinks(zk)" })
      vim.keymap.set("n", "<leader>zl", "<Cmd>ZkLinks<CR>",
                     { noremap = true, silent = true, desc = "Links(zk)" })
      vim.keymap.set("n", "<leader>zi", "<Cmd>ZkInsertLink<CR>",
                     { noremap = true, silent = true, desc = "Insert Link(zk)" })
    end,
  }
}
