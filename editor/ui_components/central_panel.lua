local UiElement = require "editor.ui_element"
local ResizeMode = require "editor.enum_resize_mode"

local CenterPanel = {}

function CenterPanel:new(x, y, w, h)
  local center_panel = UiElement:new(x, y, w, h)

  center_panel.name = "CenterPanel"
  center_panel.resizable = true
  center_panel.resizeMode = ResizeMode.HORIZONTAL_CENTER
  center_panel.minWidth = 100 -- Largura mínima

  center_panel.draw = function(self)
    local color

    if not self.visible then
      color = { 0.2, 0.2, 0.2 }   -- Desabilitado
    elseif self.hasMouseFocus and love.mouse.isDown(1) then
      color = { 0.3, 0.3, 0.9 }   -- Clicando
    elseif self.hasMouseFocus then
      color = { 0.4, 0.4, 0.6 }   -- Hover
    else
      color = { 0.15, 0.15, 0.2 } -- Normal
    end

    love.graphics.setColor(color)
    love.graphics.rectangle("fill", 0, 0, self.rect.width, self.rect.height)

    -- Debug: mostra dimensões
    love.graphics.print("Centro: " .. self.rect.width .. "x" .. self.rect.height, 10, 10)
  end
  return center_panel
end

return CenterPanel;
