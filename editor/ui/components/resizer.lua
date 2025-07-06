local UiElement = require "editor.ui_element"

local Resizer = {}

function Resizer:new(w, h, element)
  local resizerSize = 15
  local resizer = UiElement:new(w - resizerSize, h - resizerSize, resizerSize, resizerSize)

  resizer.isResizer = true
  resizer.isClickable = true

  resizer.draw = function(self)
    local color = self.parent.dragging and self.style.border_dragging or self.style.border
    love.graphics.setColor(love.math.colorFromBytes(color))
    love.graphics.polygon("fill", {
      self.rect.width, 0,
      self.rect.width, self.rect.height,
      0, self.rect.height
    })
  end

  resizer.start = function(self)
    resizer.resizer_target = self.parent
  end

  resizer.resizeTarget = function(self)
    if self.resizing then
      local mx, my = love.mouse.getPosition()
      local dx = mx - self.resizeStartMouseX
      local dy = my - self.resizeStartMouseY

      local newWidth = math.max(self.parent.minWidth or 100, self.resizeStartWidth + dx)
      local newHeight = math.max(self.parent.minHeight or 100, self.resizeStartHeight + dy)

      self.resizer_target:updateSize(newWidth, newHeight)

      -- Reposiciona o próprio resizer no canto
      self.rect.x = newWidth - resizerSize
      self.rect.y = newHeight - resizerSize

      self.resizer_target:markDirty()
    end
  end

  return resizer
end

return Resizer
