-- Hyper key definition
-- I use Hyperkey.app to bind right-command to this combination
local Hyper = {"cmd", "alt", "ctrl", "shift"}

-- Returns the first space on the current screen
function firstSpace()
  local mainScreen = hs.screen.mainScreen():getUUID()
  local screenSpaces = hs.spaces.allSpaces()[mainScreen]
  for _, spaceID in ipairs(screenSpaces) do
    return spaceID
  end
  return nil
end

-- Move all windows on the current space to the first space
function moveAllWindowsToFirstSpace()
  local currentSpace = hs.spaces.focusedSpace()
  local firstSpace = firstSpace()
  if currentSpace == firstSpace then
    return
  end

  local wins = hs.spaces.windowsForSpace(currentSpace)
  for _, id in ipairs(wins) do
    local win = hs.window.get(id)
    print("move", id, win)
    -- hs.spaces.moveWindowToSpace(win, firstSpace)
  end
end

hs.hotkey.bind(Hyper, "Z", function()
  moveAllWindowsToFirstSpace()
end)

