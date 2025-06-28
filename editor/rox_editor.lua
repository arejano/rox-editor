local UiHandler = require "editor.ui_handler"
local UiElement = require "editor.ui_element"

local ResizeMode = require "editor.enum_resize_mode"

---@class RoxEditor
---@field draw function
---@field markDirty function
---@field ui_handler UiHandler | nil
local RoxEditor = {
  ui_handler = nil,
}

RoxEditor.__index = RoxEditor

function RoxEditor:mouseMoved()
  local x, y = love.mouse.getPosition()

  local focusedElement = self.ui_handler:handleMouseMove(x, y)

  -- Você pode adicionar lógica adicional aqui
  if focusedElement then
    -- Exemplo: mudar cursor quando sobre elementos clicáveis
    if focusedElement.isClickable then
      love.mouse.setCursor(love.mouse.getSystemCursor("hand"))
    else
      love.mouse.setCursor()
    end
  end

  return focusedElement
end

function RoxEditor:new()
  local obj = setmetatable({}, RoxEditor)

  obj.ui_handler = UiHandler:new()

  -- Configura callbacks de mouse


  local w, h = GetWindowSize();
  local base_panel_width = 200

  -- Left Panel
  local panel = obj.ui_handler:addElement(UiElement:new(0, 0, base_panel_width, h))
  panel.name = "LeftPanel"
  panel.resizable = true
  panel.resizeMode = "left";
  panel.draw = function(obj)
    -- print("Desenhando o " .. obj.name)
    local x, y = obj:getAbsolutePosition()
    love.graphics.setColor(0.2, 0.2, 0.3)
    -- print(obj.rect.height)
    love.graphics.rectangle("fill", x, y, obj.rect.width, obj.rect.height)
  end

  local botao = UiElement:new(2, 2, 100, 40)
  botao.isClickable = true
  botao.draw = function(self)
    local color = self:setColorConfig();
    love.graphics.setColor(color)
    love.graphics.rectangle("fill", 0, 0, self.rect.width, self.rect.height)
  end
  panel:addChild(botao)

  local btn_2 = UiElement:new(2, 50, 190, 40)
  btn_2.isClickable = true
  btn_2.draw = function(self)
    local color = self:setColorConfig();
    love.graphics.setColor(color)
    love.graphics.rectangle("fill", 0, 0, self.parent.rect.width, self.rect.height)
  end
  panel:addChild(btn_2)


  --cantral


  -- Painel Central (novo)
  local center_panel = obj.ui_handler:addElement(UiElement:new(
    base_panel_width,
    0,
    w - 2 * base_panel_width,
    h
  ))
  center_panel.name = "CenterPanel"
  center_panel.resizable = true
  center_panel.resizeMode = ResizeMode.HORIZONTAL_CENTER
  center_panel.minWidth = 100 -- Largura mínima

  center_panel.draw = function(self)
    local color

    if not self.visible then
      color = { 0.2, 0.2, 0.2 }   -- Desabilitado
    elseif self.hasMouseFocus and love.mouse.isDown(1) then
      color = { 0.3, 0.3, 0.9 }   -- Clicando
    elseif self.hasMouseFocus then
      color = { 0.4, 0.4, 0.6 }   -- Hover
    else
      color = { 0.15, 0.15, 0.2 } -- Normal
    end

    love.graphics.setColor(color)
    love.graphics.rectangle("fill", 0, 0, self.rect.width, self.rect.height)

    -- Debug: mostra dimensões
    love.graphics.print("Centro: " .. self.rect.width .. "x" .. self.rect.height, 10, 10)
  end

  --direito


  local r_panel = obj.ui_handler:addElement(UiElement:new(w - base_panel_width, 0, base_panel_width, h))
  r_panel.name = "RightPanel"

  r_panel.resizable = true
  r_panel.resizeMode = "right";
  r_panel.draw = function(self) -- Use 'self' em vez de 'obj' para consistência
    local x, y = self:getAbsolutePosition()

    -- -- Debug: mostra informações do painel
    -- love.graphics.setColor(1, 0, 0)
    -- love.graphics.print(self.name .. " X:" .. x .. " Y:" .. y .. " W:" .. self.rect.width .. " H:" .. self.rect.height,
    --   10, 10)

    -- Desenho normal
    love.graphics.setColor(0.2, 0.2, 0.3)
    love.graphics.rectangle("fill", 0, 0, self.rect.width, self.rect.height) -- Coordenadas locais!

    -- Debug: borda vermelha para visualização
    -- love.graphics.setColor(1, 0, 0, 0.5)
    -- love.graphics.rectangle("line", 0, 0, self.rect.width, self.rect.height)
  end

  return obj;
end

---@param DirtyFlags
function RoxEditor:markDirty(flag)
  self.ui_handler:markDirty(flag)
end

function RoxEditor:draw()
  self.ui_handler:render()
end

function RoxEditor:resize()
  self.ui_handler:resize();
end

return RoxEditor
