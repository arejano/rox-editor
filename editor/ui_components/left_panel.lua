local UiElement = require "editor.ui_element"

local LeftPanel = {

}

---@param ui_handler  UiHandler
function LeftPanel:init(ui_handler)
  local panel = ui_handler:addElement(UiElement:new(0, 0, base_panel_width, h))
  panel.update_rect = function(rect)
    local w, h = GetWindowSize();
  end
  panel.name = "LeftPanel"
  panel.draw = function(obj)
    local x, y = obj:getAbsolutePosition()
    love.graphics.setColor(0.2, 0.2, 0.3)
    love.graphics.rectangle("fill", x, y, obj.rect.width, obj.rect.height)
  end
end

return LeftPanel;
