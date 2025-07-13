local UIElement = require "editor.ui_element"
local utils = require 'utils'

local central_viewer = UIElement:new(0, 40, 400, 100)
central_viewer.style.bg = { 221, 222, 224 }

central_viewer.start = function(self)
  local left = _G.main_rects.tool_panel
  local right = _G.main_rects.right_panel
  local top = _G.main_rects.top_panel

  self.rect.height = self.parent.rect.height - self.rect.y - 2
  self.rect.width = self.parent.rect.width - (left.width + right.width - 2)

  self.rect.x = left.width
end

central_viewer.draw = function(self)
  love.graphics.setColor(0, 0, 0, 0.2) -- preto com 20% de opacidade
  love.graphics.rectangle("fill", 0, 0, self.rect.width, self.rect.height)

  love.graphics.setColor(love.math.colorFromBytes(221, 222, 224))
  love.graphics.rectangle("line", 0, 0, self.rect.width - 2, self.rect.height)
end

central_viewer.watch_resize = function(self)
  local left = _G.main_rects.tool_panel
  local right = _G.main_rects.right_panel
  local top = _G.main_rects.top_panel

  self.rect.x = left.width
  self.rect.height = self.parent.rect.height - (_G.main_rects['top_panel'].height + 2)
  self.rect.width = self.parent.rect.width - (left.width + right.width - 2)
end



return central_viewer
