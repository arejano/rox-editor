local game_events     = require("games.triangle_wars.game_events")
local utils           = require("core.utils")
local c_types         = require("games.triangle_wars.c_types")

local keyboard_system = {
  running = true,
  events = { game_events.KeyboardInput },
  requires = { c_types.Controllable },
  ignores = { c_types.MovingBlocked },
  key_vectors = {
    ["w"] = { dx = 0, dy = -1 }, --Up
    ["a"] = { dx = -1, dy = 0 }, --Left
    ["s"] = { dx = 0, dy = 1 },  --Down
    ["d"] = { dx = 1, dy = 0 },  --Right
  },
}

function keyboard_system:start()
end

function keyboard_system:process(ecs, dt, event, pass)
  local pressed_keys = event.data

  -- local entity = ecs:query_first(self.requires)

  for entity in pairs(ecs:query(self.requires, self.ignores)) do
    local inMovement = false
    if entity == nil then return end

    local velocity = { dx = 0, dy = 0 }

    if pressed_keys == nil then
      ecs:remove_component(entity, c_types.Running)
      ecs:remove_component(entity, c_types.Moving)
      ecs:set_component(entity, c_types.Velocity, velocity)
    else
      for key, _ in pairs(pressed_keys) do
        if self.key_vectors[key] then
          velocity.dx = velocity.dx + self.key_vectors[key].dx
          velocity.dy = velocity.dy + self.key_vectors[key].dy
        end
      end

      if velocity.dx == -0 then velocity.dx = 0 end
      if velocity.dy == -0 then velocity.dy = 0 end
      ecs:set_component(entity, c_types.Velocity, velocity)

      if pressed_keys["q"] then
        local transform = ecs:get_component(entity, c_types.Transform).data
        transform.position.x = 0
        transform.position.y = 0
      end

      if pressed_keys["e"] then
      end

      if pressed_keys["lshift"] then
        ecs:register_component(entity, { type = c_types.Running, data = true })
      else
        ecs:remove_component(entity, c_types.Running)
      end

      ecs:register_component(entity, { type = c_types.Moving, data = true })
    end

    EventManager:emit("player_update", {
      -- moving = self.inMovement,
      -- velocity = velocity,
      -- running = running,
      -- pressed_keys = pressed_keys,
      -- player_components = ecs.entities,
      -- qt_sistemas_ativos = ecs:count_sys_runners(),
      -- system_ct = ecs.systems_by_component,
      -- ent_by_ct = ecs.entities_by_component,
      -- componentes = ecs:getActiveComponents(),
      cp = ecs.components,
      -- counters = ecs.components_counter,
      -- entities = ecs.entities,
      -- dirtys = ecs.dirty_entities,
    })
  end
end

return keyboard_system
