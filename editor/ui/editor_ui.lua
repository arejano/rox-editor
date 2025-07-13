local UiHandler = require "core.ui.handler"
local UIElement = require "core.ui.element"
local Fps = require 'core.ui.components.fps'
-- local Resizer = require "editor.ui.components.resizer"
local Row = require "core.ui.components.row"

-- local FloatBox = require 'editor.ui.components.float_box'
-- local Rect = require "editor.ui.rect"

local editor_ui = UiHandler:new();

editor_ui.rootElement = UIElement:new(0, 0, love.graphics.getWidth(), love.graphics.getHeight())
editor_ui.rootElement.name = "RootElement"

editor_ui.rootElement.draw = function(self)
  love.graphics.setColor(love.math.colorFromBytes(70, 71, 74))
  love.graphics.rectangle("fill", 0, 0, self.rect.width, self.rect.height)
end

-- editor_ui.rootElement:addChild(Fps)
-- editor_ui.rootElement:addChild(require "editor.ui.blocks.top_panel")
-- editor_ui.rootElement:addChild(require "editor.ui.blocks.tool_panel")
-- editor_ui.rootElement:addChild(require "editor.ui.blocks.central_viewer")
-- editor_ui.rootElement:addChild(require "editor.ui.blocks.right_panel")

local main_row = Row:new(0, 45, 200, 200)
main_row.watch_resize = function(self)
  self.rect.x = 0
  self:horizontal_resize_childs()
  self:vertical_resize_childs()
end



local red = UIElement:new(0, 0, 100, 100)

red.draw = function(self, color)
  love.graphics.setColor(love.math.colorFromBytes({ 250, 121, 112 }))
  love.graphics.rectangle("fill", 0, 0, self.rect.width, self.rect.height)
  love.graphics.setColor(0, 0, 0)
  love.graphics.print("width: " .. self.rect.width, 10, 10)
  love.graphics.print("x: " .. self.rect.x .. "_ y: " .. self.rect.y, 10, 30)
  print("Fuck")
end

local blue = UIElement:new(0, 0, 100, 100)
blue.draw = function(self, color)
  love.graphics.setColor(love.math.colorFromBytes({ 38, 159, 212 }))
  love.graphics.rectangle("fill", 0, 0, self.rect.width, self.rect.height)
  love.graphics.setColor(0, 0, 0)
  love.graphics.print("width: " .. self.rect.width, 10, 10)
  love.graphics.print("x: " .. self.rect.x .. "_ y: " .. self.rect.y, 10, 30)
  print("Fuck")
end

local green = UIElement:new(0, 0, 100, 100)
green.draw = function(self, color)
  love.graphics.setColor(love.math.colorFromBytes({ 30, 216, 96 }))
  love.graphics.rectangle("fill", 0, 0, self.rect.width, self.rect.height)
  love.graphics.setColor(0, 0, 0)
  love.graphics.print("width: " .. self.rect.width, 10, 10)
  love.graphics.print("x: " .. self.rect.x .. "_ y: " .. self.rect.y, 10, 30)
  -- love.graphics.print("timeSinceLastDraw: " .. self.timeSinceLastDraw, 10, 50)
  print("Fuck")
end


main_row:addChild(blue)
-- main_row:addChild(red)
main_row:addChild(green)
main_row.target_fps = 2

editor_ui.rootElement:addChild(main_row)

local fps = Fps
fps.rect.y = 4
fps.rect.x = 4
editor_ui.rootElement:addChild(fps)

editor_ui.rootElement.canvas = nil

return editor_ui
