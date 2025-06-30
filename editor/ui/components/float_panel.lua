local UiElement = require "editor.ui_element"
local Button = require 'editor.ui.components.button'

local FloatPanel = {}

function FloatPanel:new()
  local base_panel_width = 200
  local w, h = GetWindowSize();

  -- Left Panel
  local panel = UiElement:new(0, 0, 200, 40)
  panel.name = "FloatPanel"
  panel.draw = function(self)
    -- print(inspect(self.parent.rect))
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", self.rect.x, self.rect.y, self.rect.width, self.rect.height)
  end

  -- seta para baixo

  local arrow_element = UiElement:new(0, 0, 50, 50)
  arrow_element.draw = function(self)
    -- local x, y = self.rect.x, self.rect.y
    local x, y = self:getAbsolutePosition()
    print(x, y)
    local size = 40                 -- Tamanho da seta
    local color = { 0.2, 0.8, 0.2 } -- Verde

    -- Pontos do triângulo (seta para baixo)
    local points = {
      x - size / 2,
      y - size / 2, -- Ponto esquerdo superior
      x + size / 2,
      y + size / 2, -- Ponto direito superior
      x,
      y + size / 2  -- Ponto inferior central
    }

    -- Desenha a seta
    love.graphics.setColor(color)
    love.graphics.polygon("fill", points)
  end


  local circle_element = UiElement:new(40, 40, 50, 50)
  circle_element.draw = function(self)
    local x, y = self:getAbsolutePosition()
    local size = 40                 -- Tamanho da seta
    local color = { 0.2, 0.8, 0.2 } -- Verde

    -- Pontos do triângulo (seta para baixo)
    local points = {
      x - size / 2,
      y - size / 2, -- Ponto esquerdo superior
      x + size / 2,
      y + size / 2, -- Ponto direito superior
      x,
      y + size / 2  -- Ponto inferior central
    }

    -- Desenha a seta
    love.graphics.setColor(color)
    love.graphics.polygon("fill", points)
  end
  panel:addChild(arrow_element)
  -- panel:addChild(circle_element)

  return panel
end

return FloatPanel;
