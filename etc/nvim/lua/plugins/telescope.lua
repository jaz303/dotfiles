-- https://github.com/nvim-telescope/telescope.nvim

vim.pack.add({
  { src = "https://github.com/nvim-telescope/telescope.nvim", version = "master" }
})

require('telescope').setup({
  pickers = {
    buffers = {
      ignore_current_buffer = true,
      sort_lastused = true,
    },
  },
})

