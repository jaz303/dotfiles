-- OS integration
-- Currently just exposes functions to open terminal / git client
-- TODO: more advanced i3/iTerm integration (open split below and to right)

local is_mac = (vim.loop.os_uname().sysname == "Darwin")

local function launch_terminal_i3(dir, cmd)
  local exec =
      "exec alacritty --class floating_term -o 'window.dimensions.columns=150' -o 'window.dimensions.lines=35' --working-directory '" ..
      dir .. "'"

  if cmd then
    exec = exec .. " -e '" .. cmd .. "'"
  end

  vim.fn.system({ "i3-msg", exec })
end

local function launch_terminal_macos(dir, cmd)
  os.execute("open -a \"/Applications/iTerm.app\" " .. dir)
end


local function show_file_nautilus(file)
  -- TODO
end

local function show_file_finder(file)
  if vim.fn.isdirectory(file) == 1 then
    vim.fn.jobstart({ "open", file }, { detach = true })
  else
    vim.fn.jobstart({ "open", "-R", file }, { detach = true })
  end
end

--
-- Use correct function for each OS

local launch_terminal_in_dir = launch_terminal_i3
local show_in_file_explorer = show_file_nautilus

if is_mac then
  launch_terminal_in_dir = launch_terminal_macos
  show_in_file_explorer = show_file_finder
end

local M = {
  LaunchTerminalInDir = launch_terminal_in_dir,
  LaunchGitClient = function()
    if is_mac then
      os.execute("open -a \"/Applications/Sublime Merge.app\" .")
    else
      launch_terminal_in_dir(vim.fn.getcwd(), "lazygit")
    end
  end,
  LaunchTerminalInWorkspaceDir = function()
    launch_terminal_in_dir(vim.fn.getcwd())
  end,
  LaunchTerminalInFileDir = function()
    local file_path = vim.api.nvim_buf_get_name(0)
    launch_terminal_in_dir(vim.fs.dirname(file_path))
  end,
  ShowInFileExplorer = function(dir)
    show_in_file_explorer(dir)
  end,
}

vim.api.nvim_create_user_command('LaunchFloatingTerminalWS', M.LaunchTerminalInWorkspaceDir,
  { desc = 'Launch workspace terminal' })
vim.api.nvim_create_user_command('LaunchFloatingTerminalF', M.LaunchTerminalInFileDir,
  { desc = 'Launch file terminal' })
vim.api.nvim_create_user_command('LaunchGitClient', M.LaunchGitClient, { desc = 'Launch git client' })

return M
