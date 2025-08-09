vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "master" }
})

require("nvim-treesitter.configs").setup({
  ensure_installed = {
    'lua',
    'zig',
    'odin',
    'php',
    'ocaml',
    'go',
    'gomod',
    'gosum',
    'c',
    'cpp',
    'css',
    'javascript',
    'typescript',
    'xml',
    'html',
    'json',
    'make',
    'objc'
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
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
})

-- I have no idea what this does
vim.api.nvim_create_autocmd('PackChanged', {
  desc = 'Handle nvim-treesitter updates',
  group = vim.api.nvim_create_augroup('nvim-treesitter-pack-changed-update-handler', { clear = true }),
  callback = function(event)
    if event.data.kind == 'update' then
      vim.notify('nvim-treesitter updated, running TSUpdate...', vim.log.levels.INFO)
      ---@diagnostic disable-next-line: param-type-mismatch
      local ok = pcall(vim.cmd, 'TSUpdate')
      if ok then
        vim.notify('TSUpdate completed successfully!', vim.log.levels.INFO)
      else
        vim.notify('TSUpdate command not available yet, skipping', vim.log.levels.WARN)
      end
    end
  end,
})

