local UIElement = require "core.ui.element"

local Row = {}

function Row:new(x, y, w, h)
  local element        = UIElement:new(x, y, w, h)
  element.name         = "Row"

  element.draw         = function(self)
    -- print("Row:draw")
    -- print(self.style.padding)
    love.graphics.setColor(love.math.colorFromBytes({ 223, 88, 24 }))
    love.graphics.rectangle("fill", 0, 0, self.rect.width, self.rect.height)
  end

  element.watch_resize = function(self)
    self:horizontal_resize_childs()
  end

  function element:start()
    self:horizontal_resize_childs()
  end

  return element
end

return Row
