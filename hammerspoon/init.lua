--
-- init.lua — Hammerspoon configuration file
--

local hyper = {'⌃', '⌥', '⌘'}
hs.hotkey.bind(hyper, 'R', hs.reload)
-- hs.hotkey.bind(hyper, 'H', hs.toggleConsole)
-- hs.hotkey.bind(hyper, '.', hs.hints.windowHints)

--
-- Keybindings
--

hs.fnutils.each({
  { key = '`', app = 'Sublime Text' },
  { key = '1', app = 'iTerm' },
  { key = '2', app = 'Finder' },
  { key = '3', app = 'Fork' },
}, function(item)

local appActivation = function()
  hs.application.launchOrFocus(item.app)

  local app = hs.appfinder.appFromName(item.app)
  if app then
    app:activate()
    app:unhide()
  end
end

hs.hotkey.bind({'⌘', '⇧'}, item.key, appActivation)
end)

hs.loadSpoon('SpoonInstall')

--
-- Caffeine
--

local caffeine = hs.menubar.new()

local function updateCaffeineDisplay(state)
  local result
  if state then
    caffeine:setIcon('Spoons/Caffeine.spoon/caffeine-on.pdf')
    hs.alert('Caffeine enabled ☕️✅', 1)
  else
    caffeine:setIcon('Spoons/Caffeine.spoon/caffeine-off.pdf')
    hs.alert('Caffeine disabled ☕️❌', 1)
  end
end

function toggleCaffeine()
  updateCaffeineDisplay(hs.caffeinate.toggle('displayIdle'))
end

function removeCaffeine()
  caffeine:delete()
  caffeine = nil
end

if caffeine then
  caffeine:setClickCallback(toggleCaffeine)
  updateCaffeineDisplay(hs.caffeinate.get('displayIdle'))
end

--
-- Translation with DeepL
--
spoon.SpoonInstall:andUse('DeepLTranslate', {
  hotkeys = {
    translate = { {'⌥', '⌘'}, 't' },
  }
})

--
-- Window management
--

local wm = require('window-management')

hs.hotkey.bind({'⌥', '⌘'}, 'c', function() wm.windowCenter() end)
hs.hotkey.bind({'⌥', '⌘'}, 'x', function() wm.windowMaximize(0) end)
hs.hotkey.bind({'⌥', '⌘'}, 'e', function() wm.moveWindowToPosition(wm.screenPositions.left) end)
hs.hotkey.bind({'⌥', '⌘'}, 'r', function() wm.moveWindowToPosition(wm.screenPositions.right) end)

--
-- Misc
--

hs.alert.show('HS config loaded 🎉')
