local MoveDirection = require 'models.types'.MoveDirection

local movement_system = {
  events = { game_events.Tick },
  requires = {
    c_types.Controllable,
    c_types.Transform,
    c_types.FacingDirection,
    c_types.Velocity
  }
}

function movement_system:process(ecs, dt)
  local bound_id = ecs:query_first({ c_types.Bounds })
  ---@type BoundData
  local bound = ecs:get_component(bound_id, c_types.Bounds).data

  if bound == nil then return end


  for _, entity in ipairs(ecs:query(self.requires)) do
    local velocity = ecs:get_component(entity, c_types.Velocity).data
    local transform = ecs:get_component(entity, c_types.Transform).data
    local facing = ecs:get_component(entity, c_types.FacingDirection).data
    local speed = ecs:get_component(entity, c_types.Speed).data

    -- print(velocity, transform, facing, speed)

    if velocity.dx ~= 0 or velocity.dy ~= 0 then
      -- Normaliza o vetor para movimento diagonal
      local length = math.sqrt(velocity.dx ^ 2 + velocity.dy ^ 2)
      velocity.dx = (velocity.dx / length) * speed * dt
      velocity.dy = (velocity.dy / length) * speed * dt

      -- Atualiza posição
      local new_x = transform.position.x + velocity.dx
      local new_y = transform.position.y + velocity.dy


      if (new_x > bound.x) and (new_x < bound.width + 96) and (new_y > bound.y) and (new_y < (bound.height + 96)) then
        transform.position.x = new_x
        transform.position.y = new_y
      end

      -- Atualiza direção
      facing.angle = math.atan2(velocity.dy, velocity.dx)
      facing.lastCardinal = self:angle_to_cardinal(facing.angle)
      ecs:set_component(entity, c_types.InMovement, true)
      -- ecs:set_component(entity, c_types.Transform, transform)
    else
      ecs:set_component(entity, c_types.InMovement, false)
    end
  end
end

function movement_system:angle_to_cardinal(angle)
  angle = angle % (2 * math.pi)
  if angle < math.pi / 4 or angle > 7 * math.pi / 4 then
    return MoveDirection.Right
  elseif angle < 3 * math.pi / 4 then
    return MoveDirection.Down
  elseif angle < 5 * math.pi / 4 then
    return MoveDirection.Left
  else
    return MoveDirection.Up
  end
end

return movement_system
