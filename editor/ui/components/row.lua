local UiElement = require "editor.ui_element"

local Row = {}

function Row:new(x, y, w, h)
  local element = UiElement:new(x, y, w, h)

  ---@param self UiElement
  local _watch = function(self)
    self.rect.width = self.parent.rect.width - (self.parent.style.padding * 4)

    local split_size = self.rect.width / #self.childs

    local new_split_w = split_size

    for i, c in ipairs(self.childs) do
      local max_h = self.rect.height - (self.style.padding * 2)
      c.rect.x = (new_split_w * (i - 1)) + self.style.padding
      c.rect.y = self.style.padding
      c.rect.width = new_split_w - (self.style.padding * 2)
      c.rect.height = max_h
    end
  end

  element.watch_resize = _watch
  element.start = function(self)
    self:watch_resize()
  end
  return element
end

return Row;
