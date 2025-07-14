local Window = require 'core.ui.components.window'
local UIElement = require "core.ui.element"

local element = Window:new()
element.rect.width = 150
element.rect.height = 30
element.isDragable = true

local text = UIElement:new(5, 5, 60, 20)

text.draw = function(self)
  love.graphics.setColor(1, 1, 1)
  love.graphics.print("FPS: " .. love.timer.getFPS(), 0, 0)
end

element:addChild(text)

return element
