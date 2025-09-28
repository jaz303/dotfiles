return {
  --
  -- gitsigns
  {
    "lewis6991/gitsigns.nvim"
  },

  --
  -- todo-comments
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("todo-comments").setup({
        highlight = {
          -- allow pattern to include assignee e.g. "TODO(jwf):"
          pattern = [[.*<((KEYWORDS)\s*%(\(.{-1,}\))?)s*:]],
        },
        search = {
          -- allow pattern to include assignee e.g. "TODO(jwf):"
          pattern = [[\b(KEYWORDS)\s*(\(\w*\))?\s*:]],
        }
      })
    end,
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
      },
      gitbrowse = {}
    }
  },
}
