return {
  --
  -- gitsigns
  {
    "lewis6991/gitsigns.nvim"
  },

  --
  -- Scrollbar
  {
    "petertriho/nvim-scrollbar",
    config = function()
      require("scrollbar").setup()
    end
  },

  --
  -- Which Key
  {
    "folke/which-key.nvim",
    config = function()
      local wk = require("which-key")
      wk.add({
        { "<leader>f",  group = "File" },
        { "<leader>b",  group = "Buffer" },
        { "<leader>l",  group = "LSP" },
        { "<leader>r",  group = "Refactor" },
        { "<leader>s",  group = "Shunt" },
        { "<leader>.",  group = "Floating" },
        { "<leader>g",  group = "git" },
        { "<leader>gs", group = "Stage" },
      })
    end
  },

  --
  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    branch = "master",
    opts = {
      pickers = {
        buffers = {
          ignore_current_buffer = true,
          sort_lastused = true,
        },
      },
    }
  },

  --
  -- Snacks (for indent guides)
  {
    "folke/snacks.nvim",
    opts = {
      indent = {
        enabled = true,
        indent = {
          char = "▎",
        },
        animate = {
          enabled = false,
        },
        scope = {
          enabled = false,
        },
      }
    }
  },
}
