local UIElement   = require "core.ui.element"
local utils       = require("core.utils")

local BottomBar   = {}
BottomBar.__index = BottomBar


function BottomBar.new()
  local element = UIElement:new(0, 0, 100, 40)
  element.dragable = true

  element.start = function(self)
    local w, h = utils.GetWindowSize();
    self.rect.width = w
    self.rect.x = 0;
    self.rect.y = h - self.rect.height
  end

  element.watch_resize = function(self)
    local w, h = utils.GetWindowSize();
    self.rect.width = w
    self.rect.x = 0;
    self.rect.y = h - self.rect.height
  end

  return element;
end

return BottomBar
