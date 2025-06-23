_G.inspect = require "libs.inspect"
_G.love = love

function _G.GetWindowSize()
  return love.graphics.getWidth(), love.graphics.getHeight()
end
