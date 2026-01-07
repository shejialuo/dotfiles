-- We would like to load these UI plugins earlier than others
-- And we have the file organized for that purpose

return {
  -- "Mofiqul/dracula.nvim"
  -- This plugin is used to set the colorscheme
  {
    "Mofiqul/dracula.nvim",
    lazy = false,
    priority = 1500,
    config = function()
      vim.cmd([[colorscheme dracula]])
    end,
  },
  -- "folke/snacks.vim"
  -- We just define this plugin here, detail settings is located
  -- at "snacks.lua". It's essential that we initialize this plugin
  -- very early, we want to directly use "Snacks" module.
  {
    "folke/snacks.nvim",
    lazy = false,
    priority = 1000,
  },
  -- "nvim-treesitter/nvim-treesitter"
  -- This plugin is used to better use treesitter feature in neovim
  -- treesitter ref: https://tree-sitter.github.io/tree-sitter/
  -- It could provide better highlight, fold and identation
  -- However, we only use highlight and fold for simplicity
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    priority = 900,
    build = ":TSUpdate",

    config = function()
      local languages = {
        'c',
        'cpp',
        'beancount',
      },
      require('nvim-treesitter').install(languages)
        vim.api.nvim_create_autocmd('FileType', {pattern = languages,
          callback = function()
            vim.treesitter.start() -- enable highlight

            vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
            vim.wo.foldmethod = 'expr'
          end,
    })
    end,
  },
}
