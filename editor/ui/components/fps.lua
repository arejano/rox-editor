local UIElement = require "editor.ui_element"

local element = UIElement:new(0, 0, 50, 30)
element.isDragable = true

element.draw = function(self)
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("fill", 0, 0, self.rect.width, self.rect.height)
  love.graphics.setColor(0, 0, 0)
  love.graphics.print(love.timer.getFPS(), self.rect.width / 2 - 1, self.rect.height / 2 - 8)
end

return element
