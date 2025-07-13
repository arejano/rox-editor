local UIElement = require "editor.ui_element"
local Window = require 'editor.ui.components.window'

local element = Window:new()
element.isDragable = true
element.rect.width = 70
element.rect.height = 30
element.isDragable = true

local text = UIElement:new(5, 5, 60, 20)
text.transpass = true

text.draw = function(self)
  love.graphics.setColor(1, 1, 1)
  love.graphics.print("FPS: " .. love.timer.getFPS(), 0, 0)
end

element:addChild(text)

return element
