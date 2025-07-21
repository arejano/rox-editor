local game_events = require("games.triangle_wars.game_events")
local utils       = require("core.utils")
local c_types     = require("games.triangle_wars.c_types")

local move_system = {
  track = false,
  running = false,
  requires = { c_types.Transform, c_types.Player, c_types.Velocity },
  watch = { c_types.InMovement, c_types.Transform }
}

function move_system:start()
end

function move_system:process(ecs, dt, event, pass)
end

---@param ecs Ecs
function move_system:toggle_state(ecs)
end

return move_system
