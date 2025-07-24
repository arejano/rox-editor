local game_events          = require("games.triangle_wars.game_events")
local c_types              = require("games.triangle_wars.c_types")
local utils                = require("core.utils")

local spatial_index_system = {
  track = false,
  running = true,
  events = { game_events.ProcessDirtyEntities, },
  requires = {},
  octree = nil
}

function spatial_index_system:start(ecs)
  self.octree = ecs.resources["octree"][1]
end

function spatial_index_system:process(ecs, dt, event, pass)
  if not self.octree then
    self.octree = ecs.resources["octree"][1]
    return
  end

  for key, v in pairs(ecs.dirty_entities) do
    local transform = ecs:get_component(key, c_types.Transform).data

    local spatial_entity = {
      id = key,
      position = { x = transform.position.x, y = transform.position.y, z = 0 },
      size = { width = transform.size.width, height = transform.size.height, depth = 10 }
    }
    self.octree:update(spatial_entity)
    ecs.dirty_entities[key] = nil
  end

  -- EventManager:emit("player_update", { oct = self.octree.objects, })
end

return spatial_index_system
