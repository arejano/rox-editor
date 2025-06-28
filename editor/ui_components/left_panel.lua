local UiElement = require "editor.ui_element"
local Button = require 'editor.ui_components.button'

local LeftPanel = {

}

function LeftPanel:new()
  local base_panel_width = 200
  local w, h = GetWindowSize();

  -- Left Panel
  local panel = UiElement:new(0, 0, base_panel_width, h)
  panel.name = "LeftPanel"
  panel.resizable = true
  panel.resizeMode = "left";
  panel.draw = function(obj)
    local x, y = obj:getAbsolutePosition()
    love.graphics.setColor(0.2, 0.2, 0.3)
    love.graphics.rectangle("fill", x, y, obj.rect.width, obj.rect.height)
  end
  panel:addChild(Button:new(10, 10, panel.rect.width - 20, 40))
  panel:addChild(Button:new(10, 60, panel.rect.width - 20, 40))
  panel:addChild(Button:new(10, 110, panel.rect.width - 20, 40))
  panel:addChild(Button:new(10, 160, panel.rect.width - 20, 40))
  panel:addChild(Button:new(10, 210, panel.rect.width - 20, 40))
  panel:addChild(Button:new(10, 260, panel.rect.width - 20, 40))

  return panel
end

return LeftPanel;
