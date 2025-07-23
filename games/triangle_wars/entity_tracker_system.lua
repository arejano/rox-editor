local game_events             = require("games.triangle_wars.game_events")
local utils                   = require("core.utils")
local c_types                 = require("games.triangle_wars.c_types")

local entity_tracker_system   = {
  running = true,
  events = { game_events.Render },
  requires = { c_types.Renderable },
}

entity_tracker_system.__index = entity_tracker_system


function entity_tracker_system:start()
end

function entity_tracker_system:process(ecs, dt, event, pass)
  for entity in pairs(ecs:query(self.requires, self.ignores)) do
    local transform = ecs:get_component(entity, c_types.Transform).data
    local coli

    if not transform then return end

    local color

    love.graphics.setLineWidth(2)
    love.graphics.setColor(love.math.colorFromBytes({ 255, 255, 255 }))
    love.graphics.rectangle("line", transform.position.x, transform.position.y, transform.size.width, transform.size
      .height)
  end
end

return entity_tracker_system
