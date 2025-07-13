local UIElement = require "core.ui.element"
-- local Resizer = require "editor.ui.components.resizer"
-- local Row = require "editor.ui.components.row"
-- local Text = require "editor.ui.components.text"

local Window = {}
Window.__index = Window

function Window:new()
  local element = UIElement:new(10, 10, 300, 600)
  element.isDragable = true

  element.draw = function(self)
    local x, y = self.rect.x, self.rect.y
    local w, h = self.rect.width, self.rect.height
    local rx, ry = 12, 12 -- borda arredondada

    -- Sombra (deslocada e com alpha baixo)
    love.graphics.setColor(0, 0, 0, 0.2) -- preto com 20% de opacidade
    love.graphics.rectangle("fill", 0, 0, w, h, rx, ry)

    -- Retângulo principal
    love.graphics.setColor(love.math.colorFromBytes(36, 38, 39))
    love.graphics.rectangle("fill", 0, 0, w - 4, h - 4, rx, ry)
  end


  return element
end

return Window
