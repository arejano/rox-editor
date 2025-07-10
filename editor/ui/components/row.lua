local UiElement = require "editor.ui_element"

local Row = {}

function Row:new(x, y, w, h)
  local element = UiElement:new(x, y, w, h)

  function element:watch_resize()
    local parent = self.parent
    if not parent then return end

    local padding = parent.style.padding or 0
    local innerWidth = parent.rect.width - (padding * 2)
    self.rect.width = innerWidth

    local childCount = #self.childs
    if childCount == 0 then return end

    local splitSize = innerWidth / childCount
    local innerHeight = self.rect.height - (self.style.padding * 2)

    for i = 1, childCount do
      local child = self.childs[i]
      local offset = (splitSize * (i - 1)) + self.style.padding
      child.rect.x = offset
      child.rect.y = self.style.padding
      child:updateSize(splitSize - (self.style.padding * 2), innerHeight)
    end
  end

  function element:start()
    self:watch_resize()
  end

  return element
end

return Row
