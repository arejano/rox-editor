local UIElement   = require "core.ui.element"
local Window      = require("core.ui.components.window")
local utils       = require("core.utils")

local system_list = Window:new()

local player_data = UIElement:new(8, 42, 100, 100)

local data        = {
}
player_data:bindData(data)

player_data.draw         = function(self)
  local x, y = self.rect.x, self.rect.y
  local w, h = self.rect.width, self.rect.height
  local rx, ry = 0, 0 -- borda arredondada

  love.graphics.setColor(love.math.colorFromBytes(1, 1, 1))
  love.graphics.rectangle("fill", 0, 0, w - 4, h - 4, rx, ry)
  love.graphics.setColor(1, 1, 1)
  love.graphics.print(utils.inspect(self.data), 0, 0)
end

player_data.start        = function(self)
  self.rect.width = self.parent.rect.width - 20
  self.rect.height = self.parent.rect.height - 50
end

player_data.watch_resize = function(self)
  self.rect.width = self.parent.rect.width - 20
  self.rect.height = self.parent.rect.height - 50
end

player_data.consumeEvent = function(self, event)
  for k, v in pairs(event) do
    self.data[k] = v
  end
  self:markDirty()
end


EventManager:watch("player_update", player_data)

system_list:addChild(player_data)

return system_list
