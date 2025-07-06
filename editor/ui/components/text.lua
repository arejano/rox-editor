local UiElement = require "editor.ui_element"

local Text      = {}
Text.__index    = Text


---@param rect Rect
function Text:new(rect, text)
  local element = UiElement:new(rect.x, rect.y, rect.width, rect.height)
  local data = {
    text = text
  }
  element:bindData(data)
  element.transpass = true

  element.draw = function(self)
    self:drawText(self.data.text, self.style.padding, self.style.padding, 18, self.style.fg)
  end


  return element
end

return Text
