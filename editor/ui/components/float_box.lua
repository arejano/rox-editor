local UiElement = require "editor.ui_element"

local br = { x = 0, y = 0, width = 100, height = 100 }
local sr = { x = 0, y = 0, width = 100, height = 100 }


---@param rect Rect
---@param props FloatBoxProperties
local float_box = function(rect, props)
  local w = 450
  local h = 600
  local padding = 8

  local element = UiElement:new(250, 250, w, h)
  element.isDragable = true

  -- Anchor Block
  local anchor_block = UiElement:new(padding, padding, w - padding * 2, 50)
  anchor_block.isDragable = true
  anchor_block.isClickable = true
  -- Anchor Block - Draw
  anchor_block.draw = function(self)
    local bgColor = self.parent.dragging and { 0.3, 0.7, 0.3 } or { 0.7, 0.3, 0.3 }
    love.graphics.setColor(bgColor)
    love.graphics.rectangle("fill", 0, 0, self.rect.width, self.rect.height)
  end


  local ab_2 = UiElement:new(padding, 80, 80, 50)
  ab_2.isDragable = true
  ab_2.isClickable = true
  -- Anchor Block - Draw
  ab_2.draw = function(self)
    local bgColor = self.parent.dragging and { 0.3, 0.7, 0.3 } or { 0.7, 0.3, 0.3 }
    love.graphics.setColor(bgColor)
    love.graphics.rectangle("fill", 0, 0, self.rect.width, self.rect.height)
  end


  -- Anchor Block - Click
  ---@param mousedata MouseClickData
  local dragClick = function(self, mousedata)
    if mousedata.pressed then
      self.parent:beginDrag(mousedata.x, mousedata.y)
    else
      self.parent:endDrag()
    end
  end

  anchor_block.click = dragClick
  ab_2.click = dragClick

  local handleMouse = function(self)
    if self.parent.dragging then
      local mx, my = love.mouse.getPosition()
      self.parent:dragTo(mx, my)
    end
  end
  anchor_block.handleMouseMove = handleMouse
  ab_2.handleMouseMove = handleMouse

  element.draw = function(self)
    local bgColor = self.dragging and { 0.6, 0.3, 0.1 } or { 1, 1, 1 }
    love.graphics.setColor(bgColor)
    love.graphics.rectangle("fill", 0, 0, self.rect.width, self.rect.height)
  end


  element:addChild(ab_2)
  element:addChild(anchor_block)

  return element
end

return float_box
