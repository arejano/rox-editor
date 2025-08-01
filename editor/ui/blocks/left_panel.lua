local UiElement = require "editor.ui_element"
local Button = require 'editor.ui.components.button'

local LeftPanel = {

}

function LeftPanel:new()
  local base_panel_width = 200
  local w, h = GetWindowSize();

  -- Left Panel
  local panel = UiElement:new(0, 0, base_panel_width, h)
  panel.name = "LeftPanel"
  panel.resizable = true
  panel.dragable = true
  panel.resizeMode = "left";

  panel.draw = function(obj)
    local x, y = obj:getAbsolutePosition()
    love.graphics.setColor(0.2, 0.2, 0.3)
    love.graphics.rectangle("fill", 0, 0, obj.rect.width, obj.rect.height)
  end


  panel.click = function(self, mousedata)
    if mousedata.pressed then
      self:beginDrag(mousedata.x, mousedata.y)
    else
      self:endDrag()
    end
  end

  -- panel.handleMouseMove = function(self)
  --   if self.dragging then
  --     local mx, my = love.mouse.getPosition()
  --     self:dragTo(mx, my)
  --   end
  -- end

  local button_a = Button:new({ x = 10, y = 10, width = panel.rect.width - 20, height = 40 })
  button_a.click = function(self, mousedata)
    ---@type UiThemeData
    local data = GlobalState:get("ui/theme")
    data.primary = data.primary .. data.primary
    GlobalState:set("ui/theme", data)
  end


  panel:addChild(button_a)

  panel:addChild(Button:new({
      x = 10,
      y = 60,
      width = panel.rect.width - 20,
      height = 40
    },
    function()
      ---@type UiThemeData
      local data = GlobalState:get("ui/theme")
      data.primary = "novo_texto"
      GlobalState:set("ui/theme", data)
    end))
  -- panel:addChild(Button:new(10, 60, panel.rect.width - 20, 40))
  -- panel:addChild(Button:new(10, 110, panel.rect.width - 20, 40))
  -- panel:addChild(Button:new(10, 160, panel.rect.width - 20, 40))
  -- panel:addChild(Button:new(10, 210, panel.rect.width - 20, 40))
  -- panel:addChild(Button:new(10, 260, panel.rect.width - 20, 40))

  return panel
end

return LeftPanel;
