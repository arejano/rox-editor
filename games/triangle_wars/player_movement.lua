local game_events        = require("games.triangle_wars.game_events")
local utils              = require("core.utils")
local c_types            = require("games.triangle_wars.c_types")

local player_move_system = {
  running = false,
  events = { game_events.StopPlayerMove, game_events.PlayerIsMoving },
  requires = { c_types.Transform, c_types.Player, c_types.Velocity },
}

function player_move_system:start()
end

function player_move_system:process(ecs, dt, event, pass)
  if event.type == game_events.StopPlayerMove then
    self:stopMove(ecs, dt, event, pass)
    return
  end
end

function player_move_system:isMoving(ecs, dt, event, pass)
  EventManager:emit("player_update", { velocity = velocity, running = false })
end

function player_move_system:stopMove(ecs, dt, event, pass)
  local entity = ecs:query_first(self.requires)
  if entity == nil then return end

  local velocity = { dx = 0, dy = 0 }
  ecs:set_component(entity, c_types.Velocity, velocity)
  ecs:set_component(entity, c_types.Running, false)
  EventManager:emit("player_update", { velocity = velocity, running = false })
end

return player_move_system
