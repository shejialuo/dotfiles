return {
  -- "folke/persistence.nvim"
  -- This plugin is used to restore buffers just like IDE
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {
      need = 1,
      branch = false,
    },
  }
}
