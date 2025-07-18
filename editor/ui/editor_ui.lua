local UIHandler = require "core.ui.handler"
local UIElement = require "core.ui.element"
local Fps = require 'core.ui.components.fps'
local Row = require "core.ui.components.row"
local utils = require 'core.utils'


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

local main_row = Row:new(0, 0, 200, 50)



local red = UIElement:new(0, 0, 100, 100)
red.isClickable = true
red.name = "Red"
red.isDragable = true

red.draw = function(self, color)
  love.graphics.setColor(love.math.colorFromBytes({ 250, 121, 112 }))
  love.graphics.rectangle("fill", 0, 0, self.rect.width, self.rect.height)
  love.graphics.setColor(0, 0, 0)
  love.graphics.print("width: " .. self.rect.width, 10, 10)
  love.graphics.print("x: " .. self.rect.x .. "_ y: " .. self.rect.y, 10, 30)
end

local blue = UIElement:new(0, 0, 100, 100)
blue.draw = function(self, color)
  love.graphics.setColor(love.math.colorFromBytes({ 38, 159, 212 }))
  love.graphics.rectangle("fill", 0, 0, self.rect.width, self.rect.height)
  love.graphics.setColor(0, 0, 0)
  love.graphics.print("width: " .. self.rect.width, 10, 10)
  love.graphics.print("x: " .. self.rect.x .. "_ y: " .. self.rect.y, 10, 30)
end

local green = UIElement:new(0, 0, 100, 100)
green.draw = function(self, color)
  love.graphics.setColor(love.math.colorFromBytes({ 30, 216, 96 }))
  love.graphics.rectangle("fill", 0, 0, self.rect.width, self.rect.height)
  love.graphics.setColor(0, 0, 0)
  love.graphics.print("width: " .. self.rect.width, 10, 10)
  love.graphics.print("x: " .. self.rect.x .. "_ y: " .. self.rect.y, 10, 30)
end


main_row:addChild(red)
main_row:addChild(UIElement:new(0, 0, 100, 100))
main_row:addChild(blue)
main_row:addChild(UIElement:new(0, 0, 100, 100))
main_row:addChild(green)
main_row:addChild(UIElement:new(0, 0, 100, 100))

editor_ui.rootElement:addChild(main_row)


local r1 = Row:new(0, 110, 200, 50)
r1.style.padding = 10
r1:addChild(UIElement:new(0, 0, 10, 10))
r1:addChild(UIElement:new(0, 0, 10, 10))
r1:addChild(UIElement:new(0, 0, 10, 10))


local r2 = Row:new(0, 170, 200, 50)
r2.style.padding = 10
r2:addChild(UIElement:new(0, 0, 10, 10))
r2:addChild(UIElement:new(0, 0, 10, 10))
r2:addChild(UIElement:new(0, 0, 10, 10))
r2:addChild(UIElement:new(0, 0, 10, 10))
r2:addChild(UIElement:new(0, 0, 10, 10))


local r3 = Row:new(0, 240, 200, 50)
r3.style.padding = 10
r3:addChild(UIElement:new(0, 0, 10, 10))
r3:addChild(UIElement:new(0, 0, 10, 10))
r3:addChild(UIElement:new(0, 0, 10, 10))
r3:addChild(UIElement:new(0, 0, 10, 10))

editor_ui.rootElement:addChild(r1)
editor_ui.rootElement:addChild(r2)
editor_ui.rootElement:addChild(r3)


local fps = Fps
fps.rect.y = 4
fps.rect.x = 4
editor_ui.rootElement:addChild(fps)

-- local wow_bag = require "editor.ui.blocks.wow_bag"
-- editor_ui.rootElement:addChild(wow_bag)

EventManager:watch("update_fps", main_row, function(self, event)
  print(utils.inspect(event))
  if event.key == "r" then
    self.rect.y = 0
  end

  if event.key == "a" then
    self.rect.y = self.rect.y + 10
  end
end)

editor_ui.rootElement.canvas = nil

return editor_ui
