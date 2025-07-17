local game_events = require("games.triangle_wars.game_events")

local render_system = {
  events = { game_events.Render }
}

function render_system:start()
end

function render_system:process()
  print("Renderizando")
end

return render_system
