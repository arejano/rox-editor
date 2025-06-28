local UiElement = require "editor.ui_element"
local Button = require 'editor.ui_components.button'

local RightPanel = {

}

function RightPanel:new()
  local base_panel_width = 200
  local w, h = GetWindowSize();

  -- Left Panel
  local panel = UiElement:new(0, 0, base_panel_width, h)
  panel.name = "RightPanel"
  panel.resizable = true
  panel.resizeMode = "right";

  panel.draw = function(self)
    local x, y = self:getAbsolutePosition()
    love.graphics.setColor(0.2, 0.2, 0.3)
    love.graphics.rectangle("fill", x, y, self.rect.width, self.rect.height) -- Coordenadas locais!
  end

  panel:addChild(Button:new(10, 10, panel.rect.width - 20, 40))
  panel:addChild(Button:new(10, 260, panel.rect.width - 20, 40))

  return panel
end

return RightPanel;
