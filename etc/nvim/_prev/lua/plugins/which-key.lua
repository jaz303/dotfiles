-- https://github.com/folke/which-key.nvim

vim.pack.add({
  "https://github.com/folke/which-key.nvim"
})

local wk = require('which-key')
wk.add({
  { "<leader>b",  group = "Buffer" },
  { "<leader>f",  group = "File" },
  { "<leader>g",  group = "git" },
  { "<leader>.",  group = "Floating" },
  { "<leader>gs", group = "Stage" },
  { "<leader>l",  group = "LSP" },
  { "<leader>r",  group = "Refactor" },
  { "<leader>s",  group = "Shunt" },
  { "<leader>x",  group = "Diagnostics" },
})
