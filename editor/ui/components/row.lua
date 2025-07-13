local UiElement = require "editor.ui_element"

local Row = {}

function Row:new(x, y, w, h)
  local element = UiElement:new(x, y, w, h)

  element.draw = function()
    print("row!!!!")
  end

  function element:watch_resize()
    self:horizontal_resize_childs()
  end

  function element:start()
    self:horizontal_resize_childs()
  end

  return element
end

return Row
