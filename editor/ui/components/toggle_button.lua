local UiElement = require "editor.ui_element"

local toggle = {
}

function toggle:new()
  local element = UiElement:new(0, 0, 32, 32)

  element.draw = function(self)
    local bgColor = self.data.state and { 0.3, 0.7, 0.3 } or { 0.7, 0.3, 0.3 }
    love.graphics.setColor(bgColor)
    love.graphics.rectangle("fill", 0, 0, self.rect.width, self.rect.height)

    --borda
    love.graphics.setColor(love.math.colorFromBytes(224, 85, 127))
    love.graphics.rectangle("line", 0, 0, self.rect.width, self.rect.height)

    --circulo de on/off
  end

  element.data = { state = false }

  element.click = function(self)
    print(self.data.state)
    if self.data.state then
      self.data.state = false
    else
      self.data.state = true
    end
    self:markDirty()
  end

  return element
end

return toggle
