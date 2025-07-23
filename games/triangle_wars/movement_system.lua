local game_events = require("games.triangle_wars.game_events")
local utils       = require("core.utils")
local c_types     = require("games.triangle_wars.c_types")

local move_system = {
  track = false,
  running = true,
  requires = { c_types.Moving },
  watch = { c_types.Moving },
  counter = 0,
  octree = nil,
}

function move_system:start()
end

function move_system:process(ecs, dt, event, pass)
  if not self.octree then
    self.octree = ecs.resources["octree"][1]
    return
  end

  self.counter = self.counter + 1

  -- TODO: A proxima posicao so eh valida se ela nao estiver colidindo com outras entidades proximas

  for entity in pairs(ecs:query(self.requires)) do
    local velocity = ecs:get_component(entity, c_types.Velocity).data
    local transform = ecs:get_component(entity, c_types.Transform).data
    local speed = ecs:get_component(entity, c_types.Speed).data
    local running = ecs:get_component(entity, c_types.Running).data

    local inMovement = false
    local movementIsValid = true

    local newPosition = { x = transform.position.x, y = transform.position.y }

    if velocity.dx ~= 0 or velocity.dy ~= 0 then
      -- Normaliza o vetor
      local length = math.sqrt(velocity.dx ^ 2 + velocity.dy ^ 2)
      if length > 0 then
        local norm_dx = velocity.dx / length
        local norm_dy = velocity.dy / length

        -- Aplica movimento
        local adjustSpeed = running and speed * 5 or speed
        newPosition.x = transform.position.x + norm_dx * adjustSpeed * dt
        newPosition.y = transform.position.y + norm_dy * adjustSpeed * dt

        inMovement = true

        -- Check Octree - newPosition is valid?
        local check_spatial_entity = {
          id = entity,
          position = { x = newPosition.x, y = newPosition.y, z = 0 },
          size = { width = transform.size.width, height = transform.size.height, depth = 10 }
        }

        local next_colisions = self.octree:check_next_collision(check_spatial_entity)
        if utils.getSizeOfSet(next_colisions) > 0 then
          movementIsValid = false
        end
      end
    end

    if movementIsValid then
      -- Atualiza o estado de movimento se mudou
      local wasMoving = ecs:get_component(entity, c_types.Moving)
      if inMovement and not wasMoving then
        ecs:register_component(entity, { type = c_types.Moving, data = true })
      elseif not inMovement and wasMoving then
        ecs:remove_component(entity, c_types.Moving)
      end

      transform.position.x = newPosition.x
      transform.position.y = newPosition.y

      -- newPosition -> Transform
      ecs:set_component(entity, c_types.Transform, transform)

      -- Atualiza Octree
      ---@type SpatialEntity
      local spatial_entity = {
        id = entity,
        position = { x = transform.position.x, y = transform.position.y, z = 0 },
        size = { width = transform.size.width, height = transform.size.height, depth = 10 }
      }
      self.octree:update(spatial_entity)
    end
  end
end

function move_system:toggle_state(ecs)
end

return move_system
