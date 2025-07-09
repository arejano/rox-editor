local UiElement = require "editor.ui_element"

local Text      = {}
Text.__index    = Text


---@param rect Rect
function Text:new(text, rect, size, color)
  local element = UiElement:new(rect.x, rect.y, rect.width, rect.height)
  element.style.fg = color or element.style.fg
  element.style.font_size = size
  element.transpass = true

  local data = {
    text = text
  }

  element:bindData(data)
  element.transpass = true

  element.draw = function(self)
    local oldFont = love.graphics.getFont()

    if not self.style.font then
      self.style.font = love.graphics.newFont(self.style.font_size or 12) -- Tamanho adequado
      self.style.font:setFilter("nearest", "nearest")
    end

    -- 3. Aplica configurações
    love.graphics.setFont(self.style.font)
    love.graphics.setColor(self.style.fg) -- Branco sólido

    -- 4. Renderiza o texto com offsets inteiros para evitar borrão
    local new_font = love.graphics.getFont()
    local t = new_font:getHeight()
    -- local w = new_font:getWidth()


    local ix, iy = math.floor(self.rect.x), math.floor(self.rect.y)
    love.graphics.print(text, ix, iy)

    -- 5. Restaura configurações
    love.graphics.setFont(oldFont)
  end


  return element
end

return Text
