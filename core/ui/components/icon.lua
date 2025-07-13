local UiElement = require "editor.ui_element"

local icon = UiElement:new(0, 0, 32, 32)

function drawCloseIcon(x, y, size)
  love.graphics.setLineWidth(2)
  love.graphics.setColor(1, 1, 1, 1)           -- branco sólido

  love.graphics.line(x, y, x + size, y + size) -- linha /
  love.graphics.line(x + size, y, x, y + size) -- linha \
end

icon.draw = function(self)
  self:debug_box()
  drawCloseIcon(self.rect.x + self.parent.style.padding, self.rect.y + self.parent.style.padding,
    self.rect.width - self.parent.style.padding * 2)
end

icon.click = function(self)
  self.parent.click()
end


icon.onMouseEnter = function(self)
  self.parent.hasMouseFocus = true
end

icon.onMouseLeave = function(self)
  self.parent.hasMouseFocus = false
end

return icon
