local UIHandler = require "core.ui.handler"
local UIElement = require "core.ui.element"
local utils     = require("core.utils")
local Window    = require("core.ui.components.window")



local editor_ui = UIHandler:new();

editor_ui.rootElement = UIElement:new(0, 0, love.graphics.getWidth(), love.graphics.getHeight())
editor_ui.rootElement.name = "RootElement"
editor_ui.rootElement.noPropagate = true

editor_ui.rootElement.draw = function(self)
  if self then
    love.graphics.setColor(love.math.colorFromBytes(39, 37, 36))
    love.graphics.rectangle("fill", 0, 0, self.rect.width, self.rect.height)
  end
end

local window = Window:new()
local window_2 = Window:new()

editor_ui.rootElement:addChild(window)
-- editor_ui.rootElement:addChild(window_2)
editor_ui.rootElement.canvas = nil

return editor_ui
