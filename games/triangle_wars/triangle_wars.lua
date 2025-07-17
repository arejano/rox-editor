local Systems = require("games.triangle_wars.systems")
local Ecs = require("core.ecs.ecs")
local game_state = require("core.game_state")
local utils = require("core.utils")
local game_events = require("games.triangle_wars.game_events")

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

  self.ecs:add_system(require("games.triangle_wars.systems"))
  self.ecs:add_system(require("games.triangle_wars.render_system"))

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

return TriangleWarsGame
