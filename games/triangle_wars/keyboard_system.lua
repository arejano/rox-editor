local game_events     = require("games.triangle_wars.game_events")
local utils           = require("core.utils")
local c_types         = require("games.triangle_wars.c_types")

local keyboard_system = {
  running = true,
  events = { game_events.KeyboardInput },
  requires = { c_types.Controllable },
  key_vectors = {
    ["w"] = { dx = 0, dy = -1 }, --Up
    ["a"] = { dx = -1, dy = 0 }, --Left
    ["s"] = { dx = 0, dy = 1 },  --Down
    ["d"] = { dx = 1, dy = 0 },  --Right
  },
  inMovement = false,
}

function keyboard_system:start()
end

function keyboard_system:process(ecs, dt, event, pass)
  local pressed_keys = event.data

  -- local entity = ecs:query_first(self.requires)

  for entity in pairs(ecs:query(self.requires)) do
    local inMovement = false
    if entity == nil then return end

    local velocity = { dx = 0, dy = 0 }

    if pressed_keys == nil then
      ecs:remove_component(entity, c_types.Running)
      ecs:remove_component(entity, c_types.InMovement)
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
        ecs:register_component(entity, { type = c_types.InMovement, data = true })
      end

      if pressed_keys["e"] then
      end

      if pressed_keys["lshift"] then
        ecs:register_component(entity, { type = c_types.Running, data = true })
      else
        ecs:remove_component(entity, c_types.Running)
      end


      -- if velocity.dx ~= 0 or velocity.dy ~= 0 then
      --   inMovement = true
      -- end
      -- if inMovement ~= self.inMovement then
      --   self.inMovement = inMovement
      --   print("wow")
      ecs:register_component(entity, { type = c_types.InMovement, data = true })
      -- end
    end

    EventManager:emit("player_update", {
      moving = self.inMovement,
      velocity = velocity,
      -- running = running,
      -- pressed_keys = pressed_keys,
      -- player_components = ecs.entities,
      qt_sistemas_ativos = ecs:count_sys_runners(),
      -- system_ct = ecs.systems_by_component,
      -- ent_by_ct = ecs.entities_by_component,
      -- componentes = ecs:getActiveComponents(),
      cp = ecs.components,
      counters = ecs.components_counter
    })
  end
end

function keyboard_system:stopMove(ecs)
  local entity = ecs:query_first(self.requires)
  if entity == nil then return end

  local velocity = { dx = 0, dy = 0 }
  ecs:set_component(entity, c_types.Velocity, velocity)
  EventManager:emit("player_update", { velocity = velocity, running = false })
  -- EventManager:emit("systems_update", { data = ecs:getActiveComponents})
end

return keyboard_system
