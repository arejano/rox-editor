local UiElement = require "editor.ui_element"
local Button = require 'editor.ui.components.button'

local br = { x = 0, y = 0, width = 100, height = 100 }
local sr = { x = 0, y = 0, width = 100, height = 100 }


---@param rect Rect
---@param props FloatBoxProperties
local float_box = function(rect, props)
  local w = 450
  local h = 600

  local element = UiElement:new(250, 50, w, h)
  element.style.padding = 8
  element.isDragable = true

  -- resizer
  local resizerSize = 40

  local resizer = UiElement:new(w - resizerSize, h - resizerSize, resizerSize, resizerSize)
  resizer.isClickable = true
  resizer.draw = function(self)
    love.graphics.setColor(0.2, 0.6, 0.9)

    love.graphics.polygon("fill", {
      self.rect.width, 0,
      self.rect.width, self.rect.height,
      0, self.rect.height
    })
  end


  resizer.click = function(self, mousedata)
    if mousedata.pressed then
      self:startResize()
    else
      self:endResize()
    end
  end


  resizer.handleMouseMove = function(self)
    if self.resizing then
      local mx, my = love.mouse.getPosition()
      local dx = mx - self.resizeStartMouseX
      local dy = my - self.resizeStartMouseY

      local newWidth = math.max(self.parent.minWidth or 100, self.resizeStartWidth + dx)
      local newHeight = math.max(self.parent.minHeight or 100, self.resizeStartHeight + dy)

      self.parent:updateSize(newWidth, newHeight)

      -- Reposiciona o próprio resizer no canto
      self.rect.x = newWidth - resizerSize
      self.rect.y = newHeight - resizerSize

      self.parent:markDirty()
    end
  end
  element:addChild(resizer)

  -- Anchor Block
  local anchor_block = UiElement:new(element.style.padding, element.style.padding, w - element.style.padding * 2, 50)
  anchor_block.isDragable = true
  anchor_block.isClickable = true
  -- Anchor Block - Draw
  anchor_block.draw = function(self)
    local bgColor = self.parent.dragging and { 0.3, 0.7, 0.3 } or { 0.7, 0.3, 0.3 }
    love.graphics.setColor(bgColor)
    love.graphics.rectangle("fill", 0, 0, self.rect.width, self.rect.height)
  end
  anchor_block.watch_resize = function(self)
    local new_w = self.parent.rect.width - (self.parent.style.padding * 2)
    self.rect.width = new_w
  end
  anchor_block.debugging = true
  anchor_block.drag_taget = element

  local close_button = Button:new(
    {
      x = anchor_block.style.padding - anchor_block.style.padding / 2,
      y = anchor_block.style.padding - anchor_block.style.padding / 2,
      width = anchor_block.rect.height - (anchor_block.style.padding),
      height = anchor_block.rect.height - (anchor_block.style.padding)
    },
    function(self)
      print("Close Float")
    end)

  close_button.debugging = true

  local close_icon = require "editor.ui.components.icon"
  close_icon.isClickable = true
  close_icon.debugging = true
  close_button:addChild(close_icon)

  anchor_block:addChild(close_button)


  local ab_2 = UiElement:new(element.style.padding, 80, 80, 50)
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
    print("WoW")
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
  ab_2.debugging = true

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
