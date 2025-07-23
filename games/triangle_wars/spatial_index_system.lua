local game_events          = require("games.triangle_wars.game_events")
local c_types              = require("games.triangle_wars.c_types")
local utils                = require("core.utils")
local Octree               = require("core.ecs.octree")

local spatial_index_system = {
  track = false,
  running = true,
  events = { game_events.ProcessDirtyEntities, },
  requires = { c_types.Renderable },
  octree = nil
}

function spatial_index_system:start()
  self.octree = Octree.new(
    { x = 0, y = 0, z = 0, width = 10000, height = 10000, depth = 1000 }
  )
end

function spatial_index_system:process(ecs, dt, event, pass)
  for key, v in pairs(ecs.dirty_entities) do
    local transform = ecs:get_component(key, c_types.Transform).data

    local spatial_entity = {
      id = key,
      position = { x = transform.position.x, y = transform.position.y, z = 0 },
      size = { width = transform.size.width, height = transform.size.height, depth = 10 }
    }
    self.octree:update_dirty({ spatial_entity })
    ecs.dirty_entities[key] = nil
  end

  EventManager:emit("player_update", {
    oct = self.octree.objects,
  })
end

return spatial_index_system
