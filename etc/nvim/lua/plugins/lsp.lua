local settings = require("config.settings")

return {
  "folke/trouble.nvim",
  opts = {}, -- for default options, refer to the configuration section for custom setup.
  cmd = "Trouble",
  keys = {
    -- {
    --   "<leader>cl",
    --   "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
    --   desc = "LSP Definitions / references / ... (Trouble)",
    --
    -- {
    --   "<leader>xL",
    --   "<cmd>Trouble loclist toggle<cr>",
    --   desc = "Location List (Trouble)",
    -- },
    -- {
    --   "<leader>xQ",
    --   "<cmd>Trouble qflist toggle<cr>",
    --   desc = "Quickfix List (Trouble)",
    -- },
  },
}

-- return {
--   "rachartier/tiny-code-action.nvim",
--   dependencies = {
--     { "nvim-lua/plenary.nvim" },
--
--     -- optional picker via telescope
--     { "nvim-telescope/telescope.nvim" },
--     -- optional picker via fzf-lua
--     { "ibhagwan/fzf-lua" },
--     -- .. or via snacks
--     {
--       "folke/snacks.nvim",
--       opts = {
--         terminal = {},
--       }
--     }
--   },
--   event = "LspAttach",
--   opts = {},
-- }
