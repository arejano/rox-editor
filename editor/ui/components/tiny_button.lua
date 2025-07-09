local UiElement = require "editor.ui_element"

local TinyButton = {}
TinyButton.__index = TinyButton

---@param rect Rect
function TinyButton:new(rect, click)
	local button = UiElement:new(rect.x, rect.y, rect.width, rect.height);
	button.isClickable = true

	button.draw = function(self)
		if self.texture then
			self:drawTexture()
			return
		end

		love.graphics.setColor(self.style.bg)
		love.graphics.rectangle("fill", 0, 0, self.rect.width, self.rect.height)
	end

	button.click = click

	return button
end

return TinyButton;
