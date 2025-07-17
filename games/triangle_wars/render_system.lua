local game_events = require("games.triangle_wars.game_events")

local render_system = {
  events = { game_events.Render }
}

function render_system:start()
end

function render_system:process()
  love.graphics.setColor(love.math.colorFromBytes({ 250, 121, 112 }))
  love.graphics.rectangle("fill", 0, 0, 500, 500)
end

return render_system
