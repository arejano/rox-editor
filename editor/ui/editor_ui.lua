local UIHandler = require "core.ui.handler"
local UIElement = require "core.ui.element"
local Fps       = require 'core.ui.components.fps'
local utils     = require("core.utils")


local editor_ui = UIHandler:new();

editor_ui.rootElement = UIElement:new(0, 0, love.graphics.getWidth(), love.graphics.getHeight())
editor_ui.rootElement.name = "RootElement"
editor_ui.rootElement.noPropagate = true

editor_ui.rootElement.draw = function(self)
  if self then
    love.graphics.setColor(love.math.colorFromBytes(0, 0, 0, 0))
    love.graphics.rectangle("fill", 0, 0, self.rect.width, self.rect.height)
  end
end



local player_inspect = UIElement:new(0, 0, 500, editor_ui.rootElement.rect.height)
local data = {
  counter = 0,
  player_data = {}
}
player_inspect:bindData(data)
player_inspect.isDragable = true
player_inspect.draw = function(self)
  love.graphics.setColor(love.math.colorFromBytes(0, 92, 75))
  love.graphics.rectangle("fill", 0, 0, self.rect.width, self.rect.height)

  love.graphics.setColor(1, 1, 1)
  love.graphics.print(utils.inspect(self.data), 20, 20)
end

player_inspect.consumeEvent = function(self, event)
  for k, v in pairs(event) do
    self.data[k] = v
  end
  self:markDirty()
end

player_inspect.start = function(self)
  local new_x = self.parent.rect.width - self.rect.width
  self.rect.x = new_x
  self.rect.height = self.parent.rect.height
end

EventManager:watch("player_update", player_inspect)

player_inspect.watch_resize = function(self)
  self.rect.height = self.parent.rect.height
  local new_x = self.parent.rect.width - self.rect.width
  self.rect.x = new_x
end



local fps = Fps
fps.rect.y = 4
fps.rect.x = 4
editor_ui.rootElement:addChild(fps)
editor_ui.rootElement:addChild(player_inspect)

editor_ui.rootElement.canvas = nil

return editor_ui
