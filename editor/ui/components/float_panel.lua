local UiElement = require "editor.ui_element"
local Button = require 'editor.ui.components.button'

local FloatPanel = {}

function FloatPanel:new()
  local base_panel_width = 200
  local w, h = GetWindowSize();



  -- Left Panel
  local panel = UiElement:new(0, 0, 200, 40)
  panel:bindData({
    x = 0,
    y = 0
  })
  panel.name = "FloatPanel"
  panel.draw = function(self)
    local x, y = self:getAbsolutePosition()
    self.data.x = x
    self.data.y = y
    self.data.dragOffsetX = 0
    self.data.dragOffsetY = 0
    -- print(inspect(self.parent.rect))
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", 0, 0, self.rect.width, self.rect.height)
  end

  panel.click = function(self, mousedata)
    ---@type MouseClickData
    local data = mousedata
    self.dragging = data.pressed
  end

  panel.update = function(self)
    if self.dragging then
      local mx, my = love.mouse.getPosition()
      local x, y = self:getAbsolutePosition()

      self.dragOffsetX = mx - x
      self.dragOffsetY = my - y

      -- local newX = mx - self.dragOffsetX
      -- local newY = my - self.dragOffsetY

      -- self:updateRect({
      --   x = newX,
      --   y = newY,
      --   width = self.rect.width,
      --   height = self.rect.height,
      -- })
      local new_rect = {
        x = self.rect.x,
        y = self.rect.y,
        width = self.rect.width,
        height = self.rect.height,
      }
      self.rect = new_rect
      print(inspect(self.rect))

      self:markDirty()
    end
  end

  --   panel:addChild(arrow_element)
  -- panel:addChild(circle_element)

  return panel
end

return FloatPanel;
