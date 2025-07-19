local game_events        = require("games.triangle_wars.game_events")
local utils              = require("core.utils")
local c_types            = require("games.triangle_wars.c_types")

local player_move_system = {
  events = { game_events.StopPlayerMove },
  requires = { c_types.Transform, c_types.Player, c_types.Velocity },
}

function player_move_system:start()
end

function player_move_system:process(ecs, dt, event, pass)
  if event.type == game_events.StopPlayerMove then
    local entity = ecs:query_first(self.requires)

    local velocity = { dx = 0, dy = 0 }
    ecs:set_component(entity, c_types.Velocity, velocity)
    ecs:set_component(entity, c_types.Running, false)
    EventManager:emit("player_update", { velocity = velocity, running = false })
    return
  end
end

return player_move_system
