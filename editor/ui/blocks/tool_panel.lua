local UIElement = require "editor.ui_element"
local utils = require 'utils'

local tool_panel = UIElement:new(0, 40, _G.main_rects['tool_panel'].width, 100)
tool_panel.name = "tool_panel"
tool_panel.isClickable = true
tool_panel.style.bg = { 221, 222, 224 }

tool_panel.start = function(self)
  self.rect.height = self.parent.rect.height - self.rect.y

  _G.main_rects[self.name] = self.rect
end

---@param mousedata MouseClickData
tool_panel.click = function(self, mousedata)
  print(utils.inspect(main_rects))
  -- print("CLick dentro do elemento", utils.inspect(mousedata))
end

tool_panel.draw = function(self)
  love.graphics.setColor(0, 0, 0, 0.2) -- preto com 20% de opacidade
  love.graphics.rectangle("fill", 0, 0, self.rect.width, self.rect.height)

  love.graphics.setColor(love.math.colorFromBytes(221, 222, 224))
  love.graphics.rectangle("fill", 0, 0, self.rect.width - 2, self.rect.height)
end

tool_panel.watch_resize = function(self)
  self.rect.height = self.parent.rect.height - self.rect.y
end



return tool_panel
