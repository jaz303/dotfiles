-- HHVM – Hammerspoon Horizontal Window Manager
--
-- Windows are either "adopted" (managed by HHVM) or ignored.
-- Adopted windows are snapped into a horizontal region on their screen.
-- State is keyed by window ID; visibility checks handle space isolation.

local Hyper                 = { "cmd", "alt", "ctrl", "shift" }

hs.window.animationDuration = 0

-- ─── Config ───────────────────────────────────────────────────────────────────

local GAP                   = 8    -- px: applied at screen edges and between windows
local STEP                  = 0.04 -- normalized screen width added/removed per +/- press

local LAYOUTS               = {
  wide = { -- screens >= 3000px wide
    splits = { 0.275, 0.815 },
    --        left    center  right
    zoom   = { 0.40, 0.60, 0.40 }, -- target width as fraction of screen
  },
  normal = {
    splits = { 0.5 },
    zoom   = { 0.65, 0.65 },
  },
}

-- ─── State ────────────────────────────────────────────────────────────────────

-- adopted[winId] = { originalFrame = hs.geometry, regionByLayout = { wide=int, normal=int } }
-- regionByLayout stores the window's region index per layout name, so switching
-- monitors restores the correct column for each layout.
local adopted               = {}
-- widths[winId]     = normalized width override (nil = region natural width)
-- prevWidths[winId] = last zoom width before contracting, for Z to restore
local widths                = {}
local prevWidths            = {}

-- ─── Layout helpers ───────────────────────────────────────────────────────────

local function getLayoutName(screen)
  return screen:frame().w >= 3000 and "wide" or "normal"
end

local function getLayout(screen)
  return LAYOUTS[getLayoutName(screen)]
end

local function getRegions(screen)
  local layout  = getLayout(screen)
  local splits  = layout.splits
  local zoomCfg = layout.zoom
  local n       = #splits + 1
  local bounds  = { 0 }
  for _, s in ipairs(splits) do table.insert(bounds, s) end
  table.insert(bounds, 1)

  local regions = {}
  for i = 1, n do
    regions[i] = {
      index   = i,
      x1      = bounds[i],
      x2      = bounds[i + 1],
      zoom    = zoomCfg[i],
      isFirst = (i == 1),
      isLast  = (i == n),
    }
  end
  return regions
end

-- Returns the current region index for a window on a given screen.
-- Falls back across layouts and clamps to the available region count.
local function currentRegionIndex(id, screen)
  local name    = getLayoutName(screen)
  local regions = getRegions(screen)
  local rbl     = adopted[id].regionByLayout
  local ri      = rbl[name] or rbl.wide or rbl.normal or 1
  return math.min(ri, #regions)
end

-- Compute the actual screen rect for a region.
-- customWidth: normalized width override (nil = natural region width).
-- Anchoring: leftmost→right, rightmost→left, interior→symmetric.
local function regionFrame(sf, region, customWidth)
  local x1, x2 = region.x1, region.x2

  if customWidth then
    local tw = customWidth
    if region.isFirst then
      x2 = region.x1 + tw
    elseif region.isLast then
      x1 = region.x2 - tw
    else
      local cx = (region.x1 + region.x2) / 2
      x1 = cx - tw / 2
      x2 = cx + tw / 2
    end
    x1 = math.max(0, x1)
    x2 = math.min(1, x2)
  end

  -- Full GAP at screen edges; half-GAP on inner edges so adjacent windows
  -- share a full GAP between them.
  local gapL = region.isFirst and GAP or GAP / 2
  local gapR = region.isLast and GAP or GAP / 2

  return hs.geometry.rect(
    sf.x + x1 * sf.w + gapL,
    sf.y + GAP,
    (x2 - x1) * sf.w - gapL - gapR,
    sf.h - 2 * GAP
  )
end

-- Returns the region index that the window most overlaps.
local function bestRegionForWindow(win, regions, sf)
  local wf = win:frame()
  local best, bestArea = 1, -1
  for i, r in ipairs(regions) do
    local rx = sf.x + r.x1 * sf.w
    local rw = (r.x2 - r.x1) * sf.w
    local ix = math.max(0, math.min(wf.x + wf.w, rx + rw) - math.max(wf.x, rx))
    local iy = math.max(0, math.min(wf.y + wf.h, sf.y + sf.h) - math.max(wf.y, sf.y))
    local area = ix * iy
    if area > bestArea then
      bestArea = area; best = i
    end
  end
  return best
end

-- ─── Window queries ───────────────────────────────────────────────────────────

-- Build a set of window IDs visible in the current space.
-- Using visibleWindows() naturally excludes other spaces and minimised windows.
local function visibleSet()
  local s = {}
  for _, w in ipairs(hs.window.visibleWindows()) do s[w:id()] = true end
  return s
end

-- Adopted windows in a region on a screen, ordered front-to-back.
local function orderedInRegion(screen, ri)
  local vis = visibleSet()
  local result = {}
  for _, w in ipairs(hs.window.orderedWindows()) do
    local id = w:id()
    if vis[id] and w:screen() == screen and adopted[id] and
        currentRegionIndex(id, screen) == ri then
      table.insert(result, w)
    end
  end
  return result
end

-- ─── Actions ──────────────────────────────────────────────────────────────────

-- Hyper+Enter: adopt or unadopt the focused window.
local function toggleAdopt()
  local win = hs.window.focusedWindow()
  if not win then return end
  local id = win:id()

  if adopted[id] then
    win:setFrame(adopted[id].originalFrame)
    adopted[id]    = nil
    widths[id]     = nil
    prevWidths[id] = nil
  else
    local screen = win:screen()
    if not screen then return end
    local sf      = screen:frame()
    local name    = getLayoutName(screen)
    local regions = getRegions(screen)
    local ri      = bestRegionForWindow(win, regions, sf)
    adopted[id]   = { originalFrame = win:frame():copy(), regionByLayout = { [name] = ri } }
    win:setFrame(regionFrame(sf, regions[ri], nil))
    win:focus()
  end
end

-- Hyper+[ / Hyper+]: move keyboard focus to an adjacent region.
-- Skips empty regions until one with an adopted window is found.
local function focusAdjacentRegion(dir)
  local win = hs.window.focusedWindow()
  if not win or not adopted[win:id()] then return end
  local screen  = win:screen()
  local regions = getRegions(screen)
  local target  = currentRegionIndex(win:id(), screen) + dir
  while target >= 1 and target <= #regions do
    local ws = orderedInRegion(screen, target)
    if #ws > 0 then
      ws[1]:focus(); return
    end
    target = target + dir
  end
end

-- Hyper+1..5: focus the topmost adopted window in region N.
local function focusRegionN(n)
  local win     = hs.window.focusedWindow()
  local screen  = win and win:screen() or hs.screen.mainScreen()
  local regions = getRegions(screen)
  if n > #regions then return end
  local ws = orderedInRegion(screen, n)
  if #ws > 0 then ws[1]:focus() end
end

-- Hyper+Z: if at natural region width → zoom; if any wider → snap back to region width.
-- Restores the previous zoom width when expanding, if one was saved.
local function toggleZoom()
  local win = hs.window.focusedWindow()
  if not win or not adopted[win:id()] then return end
  local id       = win:id()
  local screen   = win:screen()
  local sf       = screen:frame()
  local regions  = getRegions(screen)
  local region   = regions[currentRegionIndex(id, screen)]
  local naturalW = region.x2 - region.x1
  if (widths[id] or naturalW) <= naturalW then
    widths[id] = prevWidths[id] or region.zoom
    prevWidths[id] = nil
  else
    prevWidths[id] = widths[id]
    widths[id] = nil
  end
  win:setFrame(regionFrame(sf, region, widths[id]))
  win:focus()
end

-- Hyper+- / Hyper+=: shrink or grow the focused window by STEP, min = region width.
local function adjustWidth(delta)
  local win = hs.window.focusedWindow()
  if not win or not adopted[win:id()] then return end
  local id       = win:id()
  local screen   = win:screen()
  local sf       = screen:frame()
  local regions  = getRegions(screen)
  local region   = regions[currentRegionIndex(id, screen)]
  local naturalW = region.x2 - region.x1
  local newW     = math.max(naturalW, (widths[id] or naturalW) + delta)
  widths[id]     = newW <= naturalW and nil or newW
  win:setFrame(regionFrame(sf, region, widths[id]))
  win:focus()
end

-- Hyper+Tab: cycle through adopted windows in the focused region.
-- Sorted by window ID for a stable cycle order independent of z-index.
local function cycleRegion()
  local win = hs.window.focusedWindow()
  if not win or not adopted[win:id()] then return end
  local screen = win:screen()
  local ws = orderedInRegion(screen, currentRegionIndex(win:id(), screen))
  if #ws < 2 then return end

  table.sort(ws, function(a, b) return a:id() < b:id() end)

  local id = win:id()
  for i, w in ipairs(ws) do
    if w:id() == id then
      ws[i % #ws + 1]:focus()
      return
    end
  end
end

-- move the focused window one region left/right.
local function moveToAdjacentRegion(dir)
  local win = hs.window.focusedWindow()
  if not win or not adopted[win:id()] then return end
  local id      = win:id()
  local screen  = win:screen()
  local regions = getRegions(screen)
  local target  = currentRegionIndex(id, screen) + dir
  if target < 1 or target > #regions then return end
  adopted[id].regionByLayout[getLayoutName(screen)] = target
  widths[id]                                        = nil
  prevWidths[id]                                    = nil
  win:setFrame(regionFrame(screen:frame(), regions[target], nil))
  win:focus()
end

-- Hyper+R / screen watcher: re-snap all visible adopted windows to their regions.
-- On layout change (monitor connect/disconnect), each window's stored index for
-- the new layout is used; missing entries fall back and clamp automatically.
local function reflow()
  for _, win in ipairs(hs.window.visibleWindows()) do
    local id = win:id()
    if adopted[id] then
      local screen                     = win:screen()
      local sf                         = screen:frame()
      local name                       = getLayoutName(screen)
      local regions                    = getRegions(screen)
      local ri                         = currentRegionIndex(id, screen)
      adopted[id].regionByLayout[name] = ri -- persist clamped index
      win:setFrame(regionFrame(sf, regions[ri], widths[id]))
    end
  end
end

-- ─── Launchers ────────────────────────────────────────────────────────────────

-- Extract the first plausible directory path from a window title.
-- Matches a /foo/bar-style string, verifies it exists on disk.
local function pathFromTitle(title)
  if not title then return nil end
  for candidate in title:gmatch("(/%S+)") do
    -- Need at least two components: /a/b
    if candidate:match("^/[^/]+/") then
      candidate = candidate:gsub("[,;:\"'%)%]>]+$", "") -- strip trailing punctuation
      local attr = hs.fs.attributes(candidate)
      if attr then
        if attr.mode == "directory" then return candidate end
        return candidate:match("(.+)/[^/]+$") -- file → parent dir
      end
    end
  end
  return nil
end

local function shellQuote(s)
  return "'" .. s:gsub("'", "'\\''") .. "'"
end

local function getCWD()
  local win = hs.window.focusedWindow()
  if not win then return os.getenv("HOME") end
  local app     = win:application()
  local appName = app:name()

  -- 1. Window title
  local p       = pathFromTitle(win:title())
  if p then return p end

  -- 2. App-specific AppleScript
  if appName == "Finder" then
    local ok, path = hs.osascript.applescript([[
      tell application "Finder"
        if (count of windows) > 0 then
          return POSIX path of (target of front window as alias)
        end if
      end tell
    ]])
    if ok and path and path ~= "" then return path end
  elseif appName == "iTerm2" then
    local ok, path = hs.osascript.applescript([[
      tell application "iTerm2"
        tell current session of current window
          return variable named "path"
        end tell
      end tell
    ]])
    if ok and path and path ~= "" then return path end
  end

  -- 3. Generic: lsof cwd on app PID
  local pid    = app:pid()
  local result = hs.execute("lsof -a -p " .. pid .. " -d cwd -Fn 2>/dev/null | awk '/^n/{print substr($0,2)}'")
  result       = result and result:gsub("%s+$", "")
  if result and result ~= "" then return result end

  return os.getenv("HOME")
end

local function openTerminal()
  local cwd = getCWD()
  hs.osascript.applescript(string.format([[
    tell application "iTerm2"
      set w to (create window with default profile)
      tell current session of w
        write text "cd %s && clear"
      end tell
    end tell
  ]], shellQuote(cwd)))
end

local function openFinder()
  local cwd = getCWD()
  hs.osascript.applescript(string.format([[
    tell application "Finder"
      set w to make new Finder window
      set target of w to POSIX file %s
      activate
    end tell
  ]], shellQuote(cwd)))
end

-- ─── Keybindings ──────────────────────────────────────────────────────────────

hs.hotkey.bind(Hyper, "return", toggleAdopt)
hs.hotkey.bind(Hyper, "[", function() focusAdjacentRegion(-1) end)
hs.hotkey.bind(Hyper, "]", function() focusAdjacentRegion(1) end)
hs.hotkey.bind(Hyper, "a", function() moveToAdjacentRegion(-1) end)
hs.hotkey.bind(Hyper, "s", function() moveToAdjacentRegion(1) end)
hs.hotkey.bind(Hyper, "z", toggleZoom)
hs.hotkey.bind(Hyper, "-", function() adjustWidth(-STEP) end)
hs.hotkey.bind(Hyper, "=", function() adjustWidth(STEP) end)
hs.hotkey.bind(Hyper, "r", reflow)
hs.hotkey.bind(Hyper, "tab", cycleRegion)
hs.hotkey.bind(Hyper, "t", openTerminal)
hs.hotkey.bind(Hyper, "f", openFinder)

for i = 1, 5 do
  hs.hotkey.bind(Hyper, tostring(i), function() focusRegionN(i) end)
end

-- Auto-reflow when monitors are connected or disconnected.
hs.screen.watcher.new(reflow):start()
