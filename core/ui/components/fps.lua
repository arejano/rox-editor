local Window = require 'core.ui.components.window'
local UIElement = require "core.ui.element"
local utils = require "core.utils"

local element = Window:new()
element.rect.width = 150
element.rect.height = 30
element.isDragable = true

local text = UIElement:new(5, 5, 260, 20)
text.data = { label = "FPS!!!!", update_counter = 0 }
text.transpass = true

text.draw = function(self)
  love.graphics.setColor(1, 1, 1)
  love.graphics.print(self.data.label .. " : " .. self.data.update_counter .. ":" .. love.timer.getFPS(), 0, 0)
end


text.consumeEvent = function(self, event)
  self.data.label          = event.data
  self.data.update_counter = self.data.update_counter + 1
  self:markDirty()
end


EventManager:watch("update_fps", text)
element:addChild(text)

return element
