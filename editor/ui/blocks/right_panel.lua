local UIElement          = require "editor.ui_element"

local right_panel        = UIElement:new(800, 40, 300, 100)
right_panel.style.bg     = { 221, 222, 224 }

right_panel.start        = function(self)
  self.rect.x = self.parent.rect.width - 300
  -- _G.main_rects.top_panel.width
  self.rect.height = self.parent.rect.height - self.rect.y
end

right_panel.draw         = function(self)
  love.graphics.setColor(0, 0, 0, 0.2) -- preto com 20% de opacidade
  love.graphics.rectangle("fill", 0, 0, self.rect.width, self.rect.height)

  love.graphics.setColor(love.math.colorFromBytes(221, 222, 224))
  print(self.rect.width)
  love.graphics.rectangle("fill", 2, 0, self.rect.width, self.rect.height)
end

right_panel.watch_resize = function(self)
  self.rect.x = self.parent.rect.width - self.rect.width
  self.rect.height = self.parent.rect.height - self.rect.y
end



return right_panel
