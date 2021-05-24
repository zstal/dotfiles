--
-- init.lua — Hammerspoon configuration file
--

local hyper = {'⌘', '⌥', '⌃'}
hs.hotkey.bind(hyper, 'R', hs.reload)
hs.hotkey.bind(hyper, 'H', hs.toggleConsole)
hs.hotkey.bind(hyper, '.', hs.hints.windowHints)

--
-- Keybindings
--

hs.fnutils.each({
  { key = '`', app = 'Sublime Text' },
  { key = '1', app = 'iTerm' },
  { key = '2', app = 'Finder' },
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
-- Misc
--

hs.alert.show('HS config loaded 🎉')
