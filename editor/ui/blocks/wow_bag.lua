local UIElement = require "core.ui.element"
local Row = require "core.ui.components.row"

local element = UIElement:new(100, 100, 500, 500)
element.dragable = true

element.draw = function(self)
  love.graphics.setColor(0, 0, 0, 0)
  love.graphics.rectangle("fill", 0, 0, self.rect.width, self.rect.height)
end

local background = UIElement:new(10, 10, 480, 480)
background.transpass = true
background.draw = function(self)
  love.graphics.setColor(love.math.colorFromBytes({ 30, 216, 96 }))
  love.graphics.rectangle("fill", 0, 0, self.rect.width, self.rect.height)
end


local close_button = UIElement:new(0, 10, 20, 20)
close_button.draw = function(self)
  love.graphics.setColor(love.math.colorFromBytes({ 223, 88, 24 }))
  love.graphics.rectangle("fill", 0, 0, self.rect.width, self.rect.height)
end

close_button.start = function(self)
  self.rect.x = self.parent.rect.width - self.rect.width - 10
end


local portrait = UIElement:new(0, 0, 60, 60)
portrait.draw = function(self)
  love.graphics.setColor(love.math.colorFromBytes({ 223, 88, 24 }))
  love.graphics.rectangle("fill", 0, 0, self.rect.width, self.rect.height)
end


local bag_buttons = UIElement:new(70, 30, 200, 30)
bag_buttons.draw = function(self)
  love.graphics.setColor(love.math.colorFromBytes({ 223, 88, 24 }))
  love.graphics.rectangle("fill", 0, 0, self.rect.width, self.rect.height)
end


local clean_button = UIElement:new(60, 20, 30, 30)
clean_button.draw = function(self)
  love.graphics.setColor(love.math.colorFromBytes({ 223, 88, 24 }))
  love.graphics.rectangle("fill", 0, 0, self.rect.width, self.rect.height)
end

clean_button.start = function(self)
  self.rect.x = self.parent.rect.width - self.rect.width - 10
end


element:add_child(background)
element:add_child(close_button)
element:add_child(bag_buttons)
element:add_child(clean_button)
element:add_child(portrait)

return element
