local hotkey = require "hs.hotkey"

-- window tiling management
local tiling = require "hs.tiling"
local tilemash = {"ctrl", "cmd"}

hotkey.bind(tilemash, "c", function() tiling.cycleLayout() end)
hotkey.bind(tilemash, "j", function() tiling.cycle(1) end)
hotkey.bind(tilemash, "k", function() tiling.cycle(-1) end)
hotkey.bind(tilemash, "space", function() tiling.promote() end)
hotkey.bind(tilemash, "f", function() tiling.goToLayout("fullscreen") end)

-- If you want to set the layouts that are enabled
tiling.set('layouts', {
  'fullscreen', 'main-vertical', 'ga-vertical'
})

-- window size management
--local layout = require "hs.layout"
hotkey.bind(tilemash, "m", function()
  local win = hs.window.focusedWindow()
  win:setFrame(win:screen():frame())
end)
