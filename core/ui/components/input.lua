local UiElement = require "editor.ui_element"

local Button = {

}

function Button:new(x, y, w, h)
  local button = UiElement:new(x, y, w, h);
  button.isClickable = true

  button.draw = function(self)
    local color = setColorConfig(self);
    love.graphics.setColor(color)
    love.graphics.rectangle("fill", 0, 0, self.rect.width, self.rect.height)
  end

  return button
end

function setColorConfig(self)
  local color
  if not self.visible then
    color = { 0.2, 0.2, 0.2 } -- Desabilitado
  elseif self.hasMouseFocus and love.mouse.isDown(1) then
    color = { 0.3, 0.3, 0.9 } -- Clicando
  elseif self.hasMouseFocus then
    color = { 0.5, 0.5, 0.9 } -- Hover
  else
    color = { 0.4, 0.4, 0.6 } -- Normal
  end
  return color
end

return Button;
