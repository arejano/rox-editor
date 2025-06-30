local UiElement = require "editor.ui_element"
local Button = require 'editor.ui.components.button'

local RightPanel = {

}

function RightPanel:new()
  local base_panel_width = 200
  local w, h = GetWindowSize();

  -- Left Panel
  local panel = UiElement:new(w - base_panel_width, 0, base_panel_width, h)
  panel.name = "RightPanel"
  panel.resizable = true
  panel.resizeMode = "right";

  panel.draw = function(self)
    local x, y = self:getAbsolutePosition()
    love.graphics.setColor(0.2, 0.2, 0.3)
    love.graphics.rectangle("fill", x, y, self.rect.width, self.rect.height) -- Coordenadas locais!
  end

  panel:addChild(Button:new({
      x = 10,
      y = 10,
      width = panel.rect.width - 20,
      height = 40
    },
    function()
      ---@type UiThemeData
      local data = GlobalState:get("ui/theme")
      data.primary = data.primary .. data.primary
      GlobalState:set("ui/theme", data)
    end))

  return panel
end

return RightPanel;
