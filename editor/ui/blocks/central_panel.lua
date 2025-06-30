local UiElement = require "editor.ui_element"
local ResizeMode = require "editor.enum_resize_mode"
local ToggleButton = require 'editor.ui.components.toggle_button'

---@class CenterPanale
---@field data CenterPanelData
local CenterPanel = {
}

---@class CenterPanelData
---@field state string

function CenterPanel:new(x, y, w, h)
  local center_panel = UiElement:new(x, y, w, h)

  GlobalState:watch("ui/theme", center_panel, function(self)
    self:forceRender()
  end)

  center_panel.name = "CenterPanel"
  center_panel.resizable = true
  center_panel.resizeMode = ResizeMode.HORIZONTAL_CENTER
  center_panel.minWidth = 100 -- Largura mínima

  center_panel:bindData({ state = "started", })

  center_panel:addChild(ToggleButton:new())

  center_panel.draw = function(self)
    local color = { 0.15, 0.15, 0.2 } -- Normal

    love.graphics.setColor(color)
    love.graphics.rectangle("fill", 0, 0, self.rect.width, self.rect.height)

    ---@type UiThemeData
    local data = GlobalState:get("ui/theme")

    -- Debug: mostra dimensões
    love.graphics.print(data.primary, 10, 10)
  end

  center_panel:addChild(require 'editor.ui.components.float_panel':new())

  return center_panel
end

return CenterPanel;
