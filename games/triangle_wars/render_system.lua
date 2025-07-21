local game_events   = require("games.triangle_wars.game_events")
local c_types       = require("games.triangle_wars.c_types")

local render_system = {
  running = true,
  events = { game_events.Render, },
  requires = { c_types.Transform, c_types.Renderable },
}

function render_system:start()
end

function render_system:process(ecs, dt, event, pass)
  local player = ecs:query(self.requires)

  if not player then return end

  for i, entity in ipairs(player) do
    local transform = ecs:get_component(entity, c_types.Transform).data

    love.graphics.setColor(love.math.colorFromBytes({ 250, 121, 112 }))
    love.graphics.rectangle("fill", transform.position.x, transform.position.y, transform.size.width, transform.size
      .height)
  end
end

return render_system
