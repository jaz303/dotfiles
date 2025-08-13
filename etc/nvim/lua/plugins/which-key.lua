-- https://github.com/folke/which-key.nvim

vim.pack.add({
  "https://github.com/folke/which-key.nvim"
})

local wk = require('which-key')
wk.add({
  { "<leader>f", group = "File" },
  { "<leader>b", group = "Buffer" },
  { "<leader>l", group = "LSP" },
  { "<leader>r", group = "Refactor" },
  { "<leader>s", group = "Shunt" },
})


