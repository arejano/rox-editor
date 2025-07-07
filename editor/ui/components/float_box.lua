local UiElement = require "editor.ui_element"
local Button = require 'editor.ui.components.button'
local Text = require 'editor.ui.components.text'
local Resizer = require "editor.ui.components.resizer"
local Row = require "editor.ui.components.row"

local br = { x = 0, y = 0, width = 100, height = 100 }
local sr = { x = 0, y = 0, width = 100, height = 100 }


---@param rect Rect
---@param props FloatBoxProperties
local float_box = function(rect, props)
  local w = 450
  local h = 600

  local element = UiElement:new(250, 50, w, h)
  element.style.padding = 4
  element.minHeight = 200
  element.minWidth = 200
  element.isDragable = true

  local text = Text:new({ x = 0, y = 0, width = 200, height = 32 }, "Titulo Janela")

  -- resizer
  local resizer = Resizer:new(w, h, element)
  element:addChild(resizer)

  -- Anchor Block
  local anchor_block = UiElement:new(element.style.padding, element.style.padding, w - element.style.padding * 2, 30)
  anchor_block.style.padding = 8
  anchor_block.transpass = true

  anchor_block:addChild(text)

  -- Anchor Block - Draw
  anchor_block.draw = function(self)
    love.graphics.setColor(love.math.colorFromBytes(151, 187, 195))
    love.graphics.rectangle("fill", 0, 0, self.rect.width, self.rect.height)
  end
  local _watch = function(self)
    local new_w = self.parent.rect.width - self.parent.style.padding * 2
    self.rect.width = new_w
  end
  anchor_block.watch_resize = _watch

  element.draw = function(self)
    local bgColor = self.dragging and { 0.6, 0.3, 0.1 } or { 1, 1, 1 }
    local border_color = self.dragging and self.style.border_dragging or self.style.border

    love.graphics.setColor(love.math.colorFromBytes(self.style.bg))
    love.graphics.rectangle("fill", 0, 0, self.rect.width, self.rect.height)

    love.graphics.setLineWidth(4)
    love.graphics.setColor(love.math.colorFromBytes(border_color))
    love.graphics.rectangle("line", 0, 0, self.rect.width, self.rect.height)
  end

  local row = Row:new(element.style.padding, 80, element.rect.width - 30, 50)
  row.style.padding = 4
  row:addChild(UiElement:new(0, 0, 40, row.rect.width - row.style.padding * 2))
  row:addChild(UiElement:new(0, 0, 40, row.rect.width - row.style.padding * 2))

  element:addChild(row)


  local row2 = Row:new(8, 140, element.rect.width - 30, 50)
  row2.style.padding = 4
  row2:addChild(UiElement:new(0, 0, 40, row.rect.width - row.style.padding * 2))
  row2:addChild(UiElement:new(0, 0, 40, row.rect.width - row.style.padding * 2))
  row2:addChild(UiElement:new(0, 0, 40, row.rect.width - row.style.padding * 2))
  row2:addChild(UiElement:new(0, 0, 40, row.rect.width - row.style.padding * 2))
  row2:addChild(UiElement:new(0, 0, 40, row.rect.width - row.style.padding * 2))

  element:addChild(row2)


  element:addChild(anchor_block)

  return element
end

return float_box
