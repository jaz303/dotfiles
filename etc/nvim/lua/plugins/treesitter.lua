return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    opts ={
      ensure_installed = {
        'c',
        'cpp',
        'css',
        'go',
        'gomod',
        'gosum',
        'html',
        'javascript',
        'json',
        'lua',
        'make',
        'objc',
        'ocaml',
        'odin',
        'php',
        'ruby',
        'typescript',
        'xml',
        'zig',
      },
      auto_install = false,
      highlight = {
        enable = true,
        -- set to true to run `:h syntax` and tree-sitter together.
        -- can also set it to a list of languages
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "gnn",
          node_decremental = "grm",
          node_incremental = "grn",
          scope_incremental = "grc",
        },
      },
    },
  }
}
