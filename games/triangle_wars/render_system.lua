local game_events   = require("games.triangle_wars.game_events")
local c_types       = require("games.triangle_wars.c_types")

local render_system = {
  events = { game_events.Render }
}

function render_system:start()
end

function render_system:process(ecs, dt, event, pass)
  local player = ecs:query({ c_types.Player })

  if not player then return end

  local transform = ecs:get_component(player[1], c_types.Transform).data

  love.graphics.setColor(love.math.colorFromBytes({ 250, 121, 112 }))
  love.graphics.rectangle("fill", transform.position.x, transform.position.y, transform.size.width, transform.size
    .height)
end

return render_system
