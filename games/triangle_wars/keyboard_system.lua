local game_events     = require("games.triangle_wars.game_events")
local utils           = require("core.utils")
local c_types         = require("games.triangle_wars.c_types")

local keyboard_system = {
  events = { game_events.KeyboardInput }
}

function keyboard_system:start()
end

function keyboard_system:process(ecs, dt, event, pass)
  local block = ecs:query({ c_types.Block })
  local transform = ecs:get_component(block[1], c_types.Transform).data
  print(utils.inspect(transform))
  if transform then
    transform.position.y = transform.position.position + 10
  end
end

return keyboard_system
