local UiElement = require "editor.ui_element"

local Resizer = {}

function Resizer:new(w, h, element)
  local resizerSize = 15
  local resizer = UiElement:new(w - resizerSize, h - resizerSize, resizerSize, resizerSize)

  resizer.isResizer = true
  resizer.isClickable = true

  -- Evita recriar tabela toda vez no draw
  local triangle = {
    resizerSize, 0,
    resizerSize, resizerSize,
    0, resizerSize
  }

  function resizer:draw()
    local color = self.parent.dragging and self.style.border_dragging or self.style.border
    love.graphics.setColor(love.math.colorFromBytes(color))
    love.graphics.polygon("fill", triangle)
  end

  function resizer:start()
    self.resizer_target = self.parent
  end

  function resizer:resizeTarget()
    if not self.resizing then return end

    local mx, my = love.mouse.getPosition()
    local dx = mx - self.resizeStartMouseX
    local dy = my - self.resizeStartMouseY

    local minW = self.parent.minWidth or 100
    local minH = self.parent.minHeight or 100

    local newWidth = math.max(minW, self.resizeStartWidth + dx)
    local newHeight = math.max(minH, self.resizeStartHeight + dy)

    if newWidth ~= self.parent.rect.width or newHeight ~= self.parent.rect.height then
      self.resizer_target:updateSize(newWidth, newHeight)
      self.rect.x = newWidth - resizerSize
      self.rect.y = newHeight - resizerSize
      self.resizer_target:markDirty()
    end
  end

  return resizer
end

return Resizer
