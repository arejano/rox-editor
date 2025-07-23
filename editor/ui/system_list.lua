local UIElement        = require "core.ui.element"
local utils            = require("core.utils")

local system_list      = UIElement:new(0, 0, 300, 700)
system_list.isDragable = true

EventManager:watch("systems_update", system_list)

system_list.draw = function(self)
  love.graphics.setColor(0.5, 0.5, 0.5, 0.5)
  love.graphics.rectangle("fill", 0, 0, self.rect.width, self.rect.height, 12)
end

system_list.watch_resize = function(self)
end

system_list.start = function(self)
end

system_list.consumeEvent = function(self, event)
  print(utils.inspect(event))
  self:markDirty()
end

return system_list
