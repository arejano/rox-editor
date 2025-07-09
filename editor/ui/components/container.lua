local UiElement = require "editor.ui_element"

local Container = function(x, y, w, h)
  local element = UiElement:new(x, y, w, h)
  element.transpass = true

  local _resize = function(self)
    self.rect.x = self.parent.style.padding
    local new_w = self.parent.rect.width - (self.parent.style.padding * 2)
    local new_h = self.parent.rect.height - self.rect.y - (self.parent.style.padding)
    self:resize(new_w, new_h)
  end

  element.draw = function(self)
    love.graphics.setColor(love.math.colorFromBytes(191, 32, 50))
    love.graphics.rectangle("fill", 0, 0, self.rect.width, self.rect.height)
  end

  element.start = function(self)
    _resize(self)
  end

  element.watch_resize = function(self)
    _resize(self)
  end


  return element
end

return Container
