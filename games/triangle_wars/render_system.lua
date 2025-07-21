local game_events   = require("games.triangle_wars.game_events")
local c_types       = require("games.triangle_wars.c_types")

local render_system = {
  track = false,
  running = true,
  events = { game_events.Render, },
  requires = { c_types.Renderable },
}

function render_system:start()
end

function render_system:process(ecs, dt, event, pass)
  local entities = ecs:query(self.requires)

  if not entities then return end

  for entity, status in pairs(entities) do
    local transform = ecs:get_component(entity, c_types.Transform).data

    if not transform then
      -- print("transform n existe")
      return
    end

    love.graphics.setColor(love.math.colorFromBytes({ 250, 121, 112 }))
    love.graphics.rectangle("fill", transform.position.x, transform.position.y, transform.size.width, transform.size
      .height)
  end
end

return render_system
