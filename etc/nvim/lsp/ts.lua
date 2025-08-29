return {
  cmd = { 'typescript-language-server', '--stdio' },
  filetypes = { 'typescript', 'typescript.tsx', 'typescriptreact' },
  root_markers = { '.git', 'jsconfig.json', 'package.json', 'tsconfig.json' },
  settings = {},
  init_options = { hostInfo = 'neovim' },
  single_file_support = true,
}

