--
-- https://www.reddit.com/r/neovim/comments/ypizf1/comment/ivjaeo7/

local mode_map = {
  ["n"] = "N",
  ["no"] = "O·P",
  ["nov"] = "O·P",
  ["noV"] = "O·P",
  ["no\22"] = "O·P",
  ["niI"] = "N·I",
  ["niR"] = "N·R",
  ["niV"] = "N",
  ["nt"] = "N·T",
  ["v"] = "V",
  ["vs"] = "V",
  ["V"] = "V·L",
  ["Vs"] = "V·L",
  ["\22"] = "V·B",
  ["\22s"] = "V·B",
  ["s"] = "S",
  ["S"] = "S·L",
  ["\19"] = "S·B",
  ["i"] = "I",
  ["ic"] = "I·C",
  ["ix"] = "I·X",
  ["R"] = "R",
  ["Rc"] = "R·C",
  ["Rx"] = "R·X",
  ["Rv"] = "V·R",
  ["Rvc"] = "RVC",
  ["Rvx"] = "RVX",
  ["c"] = "C",
  ["cv"] = "EX",
  ["ce"] = "EX",
  ["r"] = "R",
  ["rm"] = "M",
  ["r?"] = "C",
  ["!"] = "SH",
  ["t"] = "T",
}

local function modes()
  local vim_mode = vim.api.nvim_get_mode().mode
  return mode_map[vim_mode] or ("?? " .. vim_mode .. " ??")
end

local function width()
  return "W" .. vim.api.nvim_win_get_width(0)
end

local wm = require("local.wm")

local function index()
  return "" .. wm.GetWindowIndex(vim.api.nvim_get_current_win())
end

local filename_config = {
  'filename',
  path = 1,
  symbols = {
    modified = '*',
    readonly = 'RO'
  }
}

return {
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        disabled_filetypes = {
          statusline = { 'neo-tree', 'neo-tree-popup', 'rtb-shunt' },
          winbar = { 'neo-tree', 'neo-tree-popup', 'rtb-shunt' },
        }
      },
      sections = {
        lualine_a = { modes },
        lualine_b = { 'filename' },
        lualine_c = { 'location', 'progress', 'diagnostics' },
        lualine_x = { 'diff', 'branch' },
        lualine_y = { 'filetype' },
        lualine_z = { 'encoding', 'fileformat' },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = { 'filename' },
        lualine_c = { 'location', 'progress' },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      winbar = {
        lualine_a = {},
        lualine_b = { filename_config },
        lualine_c = {},
        lualine_x = {},
        lualine_y = { width },
        lualine_z = { index },
      },
      inactive_winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { filename_config },
        lualine_x = { width },
        lualine_y = {},
        lualine_z = { index }
      }
    }
  }
}
