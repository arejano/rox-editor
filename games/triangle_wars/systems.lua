local utils = require("core.utils")
local game_events = require("games.triangle_wars.game_events")

--- Keyboard
local keyboard_system = {
  events = { game_events.KeyboardInput }
}

function keyboard_system:start()
end

function keyboard_system:process()
  -- KeyboardManager:pressedKeys()
end



return keyboard_system
