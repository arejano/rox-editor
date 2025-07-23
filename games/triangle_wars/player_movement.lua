local game_events = require("games.triangle_wars.game_events")
local utils       = require("core.utils")
local c_types     = require("games.triangle_wars.c_types")

local move_system = {
  track = false,
  running = true,
  requires = { c_types.InMovement },
  watch = { c_types.InMovement },
  counter = 0,
}

function move_system:start()
end

function move_system:process(ecs, dt, event, pass)
  self.counter = self.counter + 1

  for entity in pairs(ecs:query(self.requires)) do
    local velocity = ecs:get_component(entity, c_types.Velocity).data
    local transform = ecs:get_component(entity, c_types.Transform).data
    local speed = ecs:get_component(entity, c_types.Speed).data
    local running = ecs:get_component(entity, c_types.Running).data

    local inMovement = false

    if velocity.dx ~= 0 or velocity.dy ~= 0 then
      -- Normaliza o vetor
      local length = math.sqrt(velocity.dx ^ 2 + velocity.dy ^ 2)
      if length > 0 then
        local norm_dx = velocity.dx / length
        local norm_dy = velocity.dy / length

        -- Aplica movimento
        local speed = running and speed * 5 or speed
        transform.position.x = transform.position.x + norm_dx * speed * dt
        transform.position.y = transform.position.y + norm_dy * speed * dt

        inMovement = true
      end
    end

    -- Atualiza o estado de movimento se mudou
    local wasMoving = ecs:get_component(entity, c_types.InMovement)
    if inMovement and not wasMoving then
      ecs:register_component(entity, { type = c_types.InMovement, data = true })
    elseif not inMovement and wasMoving then
      ecs:remove_component(entity, c_types.InMovement)
    end

    -- Atualiza o transform com a nova posição
    ecs:set_component(entity, c_types.Transform, transform)
  end
end

function move_system:toggle_state(ecs)
end

return move_system
