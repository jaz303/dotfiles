-- https://github.com/rmagatti/goto-preview

vim.pack.add({
  { src = "https://github.com/rmagatti/goto-preview", version = "v1.1.0" }
})

require('goto-preview').setup({
  width = 120,
  height = 15,
})

-- vim.keymap.set("n", "gp", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", {noremap=true})
