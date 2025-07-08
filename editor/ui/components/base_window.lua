local UiElement = require "editor.ui_element"
local TinyButton = require "editor.ui.components.tiny_button"
local Resizer = require "editor.ui.components.resizer"
local Row = require "editor.ui.components.row"

local BaseWindow = function(w, h)
  local element = UiElement:new(250, 50, w, h)
  element.style.padding = 12
  element.minHeight = 200
  element.minWidth = 200
  element.isDragable = true

  local resizer = Resizer:new(w, h, element)
  element:addChild(resizer)

  local anchor_block = Row:new(4, 4, w - element.style.padding * 2, 30)
  anchor_block.style.padding = 4
  anchor_block.transpass = true


  anchor_block.draw = function(self)
    love.graphics.setColor(love.math.colorFromBytes(151, 187, 195))
    love.graphics.rectangle("fill", 0, 0, self.rect.width, self.rect.height)
    love.graphics.setColor(0, 0, 0)
  end

  local close_button = TinyButton:new({ x = 0, y = 0, width = 22, height = 22 }, function(self, mousedata)
    if mousedata.pressed then
      print("Pressed")
    end
  end)
  close_button.watch_resize = function(self)
    self.rect.x = self.parent.rect.width - (self.rect.width + self.parent.style.padding)
  end
  close_button.style.bg = { 0, 0, 0 }

  local minimize_button = TinyButton:new({ x = 0, y = 0, width = 22, height = 22 }, function(self, mousedata)
    if mousedata.pressed then
      print("Pressed")
    end
  end)
  minimize_button.watch_resize = function(self)
    self.rect.x = self.parent.rect.width - ((self.rect.width + self.parent.style.padding) * 2)
  end
  minimize_button.style.bg = { 0, 0, 0 }


  local maximize_button = TinyButton:new({ x = 0, y = 0, width = 22, height = 22 }, function(self, mousedata)
    if mousedata.pressed then
      print("Pressed")
    end
  end)
  maximize_button.watch_resize = function(self)
    self.rect.x = self.parent.rect.width - ((self.rect.width + self.parent.style.padding) * 3)
  end
  maximize_button.style.bg = { 0, 0, 0 }

  local buttons_container = UiElement:new(0, 0, 30, 30)
  buttons_container.transpass = true
  buttons_container.draw = function(self)
  end

  buttons_container:addChild(close_button)
  buttons_container:addChild(minimize_button)
  buttons_container:addChild(maximize_button)
  anchor_block:addChild(buttons_container)


  element.draw = function(self)
    local bgColor = self.dragging and { 0.6, 0.3, 0.1 } or { 1, 1, 1 }
    local border_color = self.dragging and self.style.border_dragging or self.style.border

    love.graphics.setColor(love.math.colorFromBytes(self.style.bg))
    love.graphics.rectangle("fill", 0, 0, self.rect.width, self.rect.height)

    love.graphics.setLineWidth(4)
    love.graphics.setColor(love.math.colorFromBytes(border_color))
    love.graphics.rectangle("line", 0, 0, self.rect.width, self.rect.height)
  end

  element:addChild(anchor_block)
  return element
end

return BaseWindow
