local UiElement = require "editor.ui_element"

local OutOffSize = {}
OutOffSize.__index = OutOffSize

function OutOffSize:new()
  local uiOutOffSizeElement = UiElement:new(0, 0, love.graphics.getWidth(), love.graphics.getHeight())
  uiOutOffSizeElement.name = "OutOffSizeElement"
  uiOutOffSizeElement.draw = function(_)
    local w, h = GetWindowSize()
    love.graphics.clear()
    -- love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 0, 0, w, h)

    local font = love.graphics.newFont(42)
    love.graphics.setFont(font)

    -- Texto que será exibido
    local text = "ERRO"

    -- Obtém as dimensões do texto
    local textWidth = font:getWidth(text)
    local textHeight = font:getHeight()

    -- Calcula a posição centralizada
    local x = (w - textWidth) / 2
    local y = (h - textHeight) / 2

    -- Desenha o texto
    love.graphics.setColor(1, 0, 0) -- Vermelho
    love.graphics.print(text, x, y)
  end
  return uiOutOffSizeElement
end

return OutOffSize
