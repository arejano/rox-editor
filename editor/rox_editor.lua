local UiHandler = require "editor.ui_handler"
local UiElement = require "editor.ui_element"

local RoxEditor = {
  ui_handler = nil,
}

RoxEditor.__index = RoxEditor

function RoxEditor:new()
  -- local ui_handler = UiHandler:new()

  -- local editor = {
  --   ui_handler = ui_handler,
  -- }

  local self = setmetatable({}, RoxEditor)

  self.ui_handler = UiHandler:new()

  local w, h = GetWindowSize();
  local panel = self.ui_handler:addElement(UiElement:new(0, 0, 200, h))
  panel.draw = function(self)
    local x, y = self:getAbsolutePosition()
    love.graphics.setColor(0.2, 0.2, 0.3)
    love.graphics.rectangle("fill", x, y, self.rect.width, self.rect.height)
  end

  return self;
end

function RoxEditor:draw()
  self.ui_handler:render()
  -- print(inspect(self.ui_handler))
end

return RoxEditor
