--
-- init.lua — Hammerspoon configuration file
--

local hyper = {'⌃', '⌥', '⌘'}
hs.hotkey.bind(hyper, 'R', hs.reload)
hs.hotkey.bind(hyper, 'H', hs.toggleConsole)
hs.hotkey.bind(hyper, 'K', hs.console.clearConsole)

--
-- Keybindings
--

hs.fnutils.each({
  { key = '`', app = 'Sublime Text' },
  { key = '1', app = 'Ghostty' },
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

--
-- WindowHalfsAndThirds
--
hs.loadSpoon('WindowHalfsAndThirds')

local centerPaddingRatioX = 0.10
local centerPaddingRatioY = 0.05

local function centerWithPadding()
  local win = hs.window.focusedWindow()
  if not win then return end
  local screen = win:screen():frame()
  local paddingX = screen.w * centerPaddingRatioX
  local paddingY = screen.h * centerPaddingRatioY
  win:setFrame({
    x = screen.x + paddingX,
    y = screen.y + paddingY,
    w = screen.w - paddingX * 2,
    h = screen.h - paddingY * 2,
  })
end

spoon.WindowHalfsAndThirds.center = centerWithPadding

spoon.WindowHalfsAndThirds:bindHotkeys({
  -- bottom_half = { {'⌃', '⌘'}, 'Down' },
  -- max_toggle  = { {'⌃', '⌘'}, 'X' },
  -- top_half    = { {'⌃', '⌘'}, 'Up' },
  center      = { {'⌃', '⌘'}, '2' },
  left_half   = { {'⌃', '⌘'}, '1' },
  right_half  = { {'⌃', '⌘'}, '3' },
})

--
-- Caffeine
--

local caffeine = hs.menubar.new()

local function updateCaffeineDisplay(state)
  local result
  if state then
    caffeine:setIcon('Spoons/Caffeine.spoon/caffeine-on.pdf')
    hs.alert('☕️✅', 1)
  else
    caffeine:setIcon('Spoons/Caffeine.spoon/caffeine-off.pdf')
    hs.alert('☕️❌', 1)
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
-- Audio balance fix
--

function isEqual(a, b)
  epsilon = 1e-10
  return math.abs(a - b) <= epsilon
end

function fixAudioBalance()
  local device = hs.audiodevice.defaultOutputDevice()
  if not device then print('[fixAudioBalance] device not available'); return end
  local actualBalance = device:balance()
  if not actualBalance then print('[fixAudioBalance] balance not available'); return end
  local wantedBalance = 0.5
  if not isEqual(actualBalance, wantedBalance) then
    device:setBalance(wantedBalance)
    hs.alert('Audio balance fixed 🎧✅', 1)
  end
end

hs.audiodevice.watcher.setCallback(function(event)
  if event == 'dev#' or event == 'dOut' then
    fixAudioBalance()
  end
end)
hs.audiodevice.watcher.start()

--
-- Misc
--

hs.alert.show('HS config loaded 🎉')
