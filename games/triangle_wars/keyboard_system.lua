local game_events     = require("games.triangle_wars.game_events")
local utils           = require("core.utils")
local c_types         = require("games.triangle_wars.c_types")

local keyboard_system = {
  running = true,
  events = { game_events.KeyboardInput },
  requires = { c_types.Velocity, c_types.Controllable },
  key_vectors = {
    ["w"] = { dx = 0, dy = -1 }, --Up
    ["a"] = { dx = -1, dy = 0 }, --Left
    ["s"] = { dx = 0, dy = 1 },  --Down
    ["d"] = { dx = 1, dy = 0 },  --Right
  }
}

function keyboard_system:start()
end

function keyboard_system:process(ecs, dt, event, pass)
  local pressed_keys = event.data
  -- if pressed_keys == nil then
  --   ecs:add_event({ type = game_events.StopPlayerMove, data = nil })
  --   return
  -- end

  local entity = ecs:query_first(self.requires)

  -- if entity == nil then return end
  return

  -- local velocity = { dx = 0, dy = 0 }
  -- local running = pressed_keys["lshift"]
  -- for key, _ in pairs(pressed_keys) do
  --   if self.key_vectors[key] then
  --     velocity.dx = velocity.dx + self.key_vectors[key].dx
  --     velocity.dy = velocity.dy + self.key_vectors[key].dy
  --   end
  -- end

  -- if pressed_keys["q"] then
  --   ecs:register_component(entity, { type = c_types.Dead, data = true })
  -- end

  -- if pressed_keys["e"] then
  --   ecs:remove_component(entity, { type = c_types.Dead, data = true })
  -- end


  -- ecs:set_component(entity, c_types.Running, running)
  -- ecs:set_component(entity, c_types.Velocity, velocity)
  -- EventManager:emit("player_update", {
  --   velocity = velocity,
  --   running = running,
  --   pressed_keys = pressed_keys,
  --   player_components = ecs.entities[entity]
  -- })
end

return keyboard_system
