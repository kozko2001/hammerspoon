-- First execute the init.sh to download all the spoons
hs.alert.show("hammerspoon is initialized")

local hyper = {'ctrl', 'alt', 'cmd'}
local hyperShift = {'ctrl', 'alt', 'cmd', 'shift'}

-- Install spoons
hs.loadSpoon("SpoonInstall")
spoon.use_syncinstall = true
spoon.SpoonInstall:andUse("ReloadConfiguration")
spoon.SpoonInstall:andUse("Emojis")
spoon.SpoonInstall:andUse("TextClipboardHistory")
spoon.SpoonInstall:andUse("UnsplashZ")

-- Reload configuration using a Spoon
spoon.ReloadConfiguration:start()

-- emojis shows
spoon.Emojis:bindHotkeys({toggle = {hyper, 'f1'}})

-- show clipboard history
hs.hotkey.bind(hyper, "v", function() spoon.TextClipboardHistory:toggleClipboard() end)
spoon.TextClipboardHistory:start()

-- Window management

-- remove animations
hs.window.animationDuration = 0

-- set the default grid for all screens
hs.grid.setGrid'3x3'

hs.hotkey.bind(hyper, "right", function() moveWindow(1) end)
hs.hotkey.bind(hyper, "left", function() moveWindow(-1) end)
hs.hotkey.bind(hyper, "up", function() hs.grid.maximizeWindow() end)
hs.hotkey.bind(hyper, "down", function() fillVertical() end)

hs.hotkey.bind(hyperShift, "right", function() moveWindowToScreen(1) end)
hs.hotkey.bind(hyperShift, "left", function() moveWindowToScreen(-1) end)


-- Move the current focused window on the grid
-- expand the window if the windows is smaller than the halt
-- move the window if the window is bigger than half the grid
function moveWindow(direction)
  local w = hs.window.frontmostWindow()
  local s = w:screen()

  local grid = hs.grid.getGrid(s)
  local gridCell = hs.grid.get(w)
  local halfWidth = math.ceil(grid.w / 2.0)

  local left = direction < 0
  local right = direction > 0

  -- Try to move if width is already 3 of 5
  if gridCell.w >= halfWidth then
    -- if there is space to the right, and we want to move to the right
    if right and gridCell.x2 < grid.w then
      hs.grid.pushWindowRight(w)
      return
    end

    -- if there is space to the right and we want to move to the left
    if left and gridCell.x > 0 then
      hs.grid.pushWindowLeft(w)
      return
    end
  end

  if right then
    if gridCell.x2 > halfWidth then
      hs.grid.resizeWindowThinner(w)
      hs.grid.pushWindowRight(w)
    else
      hs.grid.resizeWindowWider(w)
    end
  end

  if left then
    if gridCell.x < halfWidth then
      hs.grid.resizeWindowThinner(w)
      hs.grid.pushWindowLeft(w)
    else
      hs.grid.resizeWindowWider(w)
    end
  end
end

function fillVertical()
  local w = hs.window.frontmostWindow()
  local s = w:screen()

  local grid = hs.grid.getGrid(s)
  local gridCell = hs.grid.get(w)

  gridCell.y = 0
  gridCell.h = grid.h

  hs.grid.set(w, gridCell)
end

-- Move the current window to another screen
function moveWindowToScreen(direction)
  local w = hs.window.frontmostWindow()
  local s = w:screen()
  local nextScreen

  if direction > 0 then
    nextScreen = s:toEast()
  else
    nextScreen = s:toWest()
  end

  w:moveToScreen(nextScreen)
end

-- Applications

local apps = {
  c = 'Firefox',
  e = 'Emacs',
  f = 'Finder',
  t = 'iTerm',
  p = 'KeePassXC',
  s = 'Slack',
  m = 'Microsoft Outlook',
  z = 'Zoom.us'
}

for key, app in pairs(apps) do
  hs.hotkey.bind(hyper, key, function() print(hs.application.launchOrFocus(app)) end)
end

hs.hotkey.bind(hyper, "e", function() hs.application.find("Emacs"):activate() end)

-- Music control using VOX
hs.hotkey.bind(hyperShift, 'p', function() hs.vox.playpause() end )
hs.hotkey.bind(hyperShift, '1', function() hs.vox.next() end )
hs.hotkey.bind(hyperShift, '2', function() hs.vox.previous() end )

