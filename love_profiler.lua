local LoveProfiler = {
  running = false,
}
LoveProfiler.__index = LoveProfiler


function LoveProfiler.new()
  local self = {}
  setmetatable(self, LoveProfiler)
  return self
end

function LoveProfiler:start()
  love.profiler = require("libs.profile.profile")
  love.profiler.start()
  love.frame = 0
end

function LoveProfiler:update(_)
  love.frame = love.frame + 1
  if love.frame % 60 == 0 then
    love.report = love.profiler.report(150)
    love.profiler.reset()
  end
end

function LoveProfiler:draw()
  love.graphics.print(love.report or "Please wait...")
end

return LoveProfiler
