local Systems = require("games.triangle_wars.systems")
local Ecs = require("core.ecs.ecs")
local game_state = require("core.game_state")
local utils = require("core.utils")
local game_events = require("games.triangle_wars.game_events")
local c_types = require("games.triangle_wars.c_types")

---@class TriangleWarsGame
---@field ecs Ecs | nil
local TriangleWarsGame = {
  game_state = 1,
  ecs = nil,
  dt = 0,

}

TriangleWarsGame.__index = TriangleWarsGame

function TriangleWarsGame:new()
  local self = {
    ecs = Ecs:new()
  }

  self.ecs:add_system(require("games.triangle_wars.keyboard_system"))
  self.ecs:add_system(require("games.triangle_wars.render_system"))
  self.ecs:add_system(require("games.triangle_wars.player_movement"))

  self.ecs:add_entity({
    { type = c_types.Player,       data = true },
    { type = c_types.Controllable, data = true },
    { type = c_types.Running,      data = false },
    { type = c_types.Velocity,     data = { dx = 0, dy = 0 } },
    {
      type = c_types.Transform,
      data = {
        position = { x = 0, y = 0 },
        scale = { sx = 0, sy = 0 },
        angle = 0,
        rotation = { ox = 0, oy = 0, },
        size = {
          width = 100,
          height = 100
        }
      }
    }
  })

  self.ecs:add_entity({
    { type = c_types.Velocity, data = { dx = 0, dy = 0 } },
  })

  return setmetatable(self, TriangleWarsGame)
end

---@param dt number
function TriangleWarsGame:update(dt)
  self.ecs:update(dt)
end

function TriangleWarsGame:draw()
  self.ecs:add_event({
    type = game_events.Render,
    data = nil
  })
  self.ecs:update(self.dt)
end

function TriangleWarsGame:newEvent(event)
  self.ecs:add_event(event)
end

return TriangleWarsGame
