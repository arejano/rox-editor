local UiElement = require "editor.ui_element"

local Row = {}

function Row:new(x, y, w, h)
  local element = UiElement:new(x, y, w, h)

  ---@param self UiElement
  local _watch = function(self)
    self.rect.width = self.parent.rect.width - (self.parent.style.padding * 2)

    local split_size = self.rect.width / #self.childs

    for i, c in ipairs(self.childs) do
      local max_h = self.rect.height - (self.style.padding * 2)
      c.rect.x = (split_size * (i - 1)) + self.style.padding
      c.rect.y = self.style.padding
      c:updateSize(split_size - (self.style.padding * 2), max_h)
    end
  end

  element.watch_resize = _watch
  element.start = function(self)
    self:watch_resize()
  end
  return element
end

return Row;
