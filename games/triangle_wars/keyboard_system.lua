local game_events     = require("games.triangle_wars.game_events")
local utils           = require("core.utils")
local c_types         = require("games.triangle_wars.c_types")

local keyboard_system = {
  events = { game_events.KeyboardInput },
  requires = { c_types.Transform, c_types.Player },
  key_vectors = {
    ["w"] = { dx = 0, dy = -1 }, --Up
    ["a"] = { dx = -1, dy = 0 }, --Left
    ["s"] = { dx = 0, dy = 1 },  --Down
    ["d"] = { dx = 1, dy = 0 },  --Right
  }
}

function keyboard_system:start()
end

---@param event KeyboardEventData
function keyboard_system:process(ecs, dt, event, pass)
  if event.data == nil then
    ecs:add_event({ type = game_events.StopPlayerMove, data = nil })
    return
  end

  local entity = ecs:query_first(self.requires)

  local pressed_keys = event.data
  local velocity = { dx = 0, dy = 0 }
  for key, _ in pairs(pressed_keys) do
    if self.key_vectors[key] then
      velocity.dx = velocity.dx + self.key_vectors[key].dx
      velocity.dy = velocity.dy + self.key_vectors[key].dy
    end
  end


  local running = pressed_keys["lshift"]
  ecs:set_component(entity, c_types.Velocity, velocity)
  ecs:set_component(entity, c_types.Running, running)
  EventManager:emit("player_update", { velocity = velocity, running = running })
end

return keyboard_system
