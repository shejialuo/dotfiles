return {
  cmd = {
    "clangd",  -- 使用完整路径
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
  },
  root_markers = {  -- 改为 root_markers
    '.clangd',
    'compile_commands.json',
    '.git'
  }
}
