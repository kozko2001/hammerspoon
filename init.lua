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
-- spoon.SpoonInstall:andUse("UnsplashRandom")

-- Reload configuration using a Spoon
spoon.ReloadConfiguration:start()

-- emojis shows
--spoon.Emojis:bindHotkeys({toggle = {hyper, 'f1'}})

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
  -- c = 'Google Chrome',
  c = 'Arc',
  f = 'Finder',
  t = 'wezterm',
  p = 'KeePassXC',
  s = 'Slack',
  z = 'Zoom.us',
  -- x = 'Tuple',
  n = 'Obsidian',
  d = 'Google Chat',
  i = 'phpStorm',
  v = 'Visual Studio Code',
}

for key, app in pairs(apps) do
  hs.hotkey.bind(hyper, key, function() print(hs.application.launchOrFocus(app)) end)
end

-- copied from https://liuhao.im/english/2017/06/02/macos-automation-and-shortcuts-with-hammerspoon.html
function chrome_switch_to(ppl)
    return function()
        hs.application.launchOrFocus("Arc")
        local chrome = hs.appfinder.appFromName("Arc")
        local str_menu_item
        if ppl == "Incognito" then
            str_menu_item = {"File", "New Incognito Window"}
        else
            str_menu_item = {"Spaces", ppl}
        end
        local menu_item = chrome:findMenuItem(str_menu_item)
        if (menu_item) then
            chrome:selectMenuItem(str_menu_item)
        end
    end
end

--- open different Chrome users
hs.hotkey.bind(hyper, "1", chrome_switch_to("ThoughtWorks"))
hs.hotkey.bind(hyper, "2", chrome_switch_to("Civitatis"))
hs.hotkey.bind(hyper, "0", chrome_switch_to("Jordi"))


