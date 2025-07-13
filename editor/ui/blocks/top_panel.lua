local UIElement = require "editor.ui_element"

local top_panel = UIElement:new(0, 0, 400, 40)
top_panel.style.bg = { 221, 222, 224 }

top_panel.start = function(self)
  self.rect.width = self.parent.rect.width
end

top_panel.draw = function(self)
  -- Sombra (deslocada e com alpha baixo)
  love.graphics.setColor(0, 0, 0, 0.1) -- preto com 20% de opacidade
  love.graphics.rectangle("fill", 0, 0, self.rect.width, self.rect.height)

  love.graphics.setColor(love.math.colorFromBytes(221, 222, 224))
  love.graphics.rectangle("fill", 0, 0, self.rect.width, self.rect.height - 2)


  love.graphics.setColor(0, 0, 0, 0.5) -- preto com 20% de opacidade
  love.graphics.rectangle("fill", 0, 0, self.rect.width, 1)
end

top_panel.watch_resize = function(self)
  self.rect.width = self.parent.rect.width
end



return top_panel
