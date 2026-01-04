-- We would like to load these UI plugins earlier than others
-- And we have the file organized for that purpose

return {
  {
    "Mofiqul/dracula.nvim",
    lazy = false,
    priority = 1500,
    config = function()
      vim.cmd([[colorscheme dracula]])
    end,
  },
  {
    "folke/snacks.nvim",
    lazy = false,
    priority = 1000,
  },
}
