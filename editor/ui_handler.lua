local UiElement = require "editor.ui_element"

local UiController = {
  rootElement = nil,
  mouseController = nil -- Referência ao controlador de mouse
}
UiController.__index = UiController

function UiController:new()
  local self = setmetatable({}, UiController)
  self.rootElement = UiElement:new(0, 0, love.graphics.getWidth(), love.graphics.getHeight())
  -- self.mouseController = mouseController
  return self
end

-- Atualiza toda a UI
function UiController:update(dt)
  -- Atualiza hierarquia de elementos
  self.rootElement:update(dt)

  -- Aqui você pode integrar com o mouseController para eventos
  -- Exemplo:
  -- local mx, my = self.mouseController:getPosition()
  -- self:handleMouseEvents(mx, my)
end

-- Renderiza toda a UI
function UiController:render()
  love.graphics.push()
  self.rootElement:render()
  love.graphics.pop()
end

-- Adiciona um elemento na raiz
function UiController:addElement(element)
  return self.rootElement:addChild(element)
end

-- Remove um elemento da raiz
function UiController:removeElement(element)
  return self.rootElement:removeChild(element)
end

-- Função para encontrar elemento sob o mouse (útil para eventos)
function UiController:getElementAt(x, y)
  local function checkElement(element, x, y)
    local ex, ey = element:getAbsolutePosition()
    local w, h = element.rect.width, element.rect.height

    if x >= ex and x <= ex + w and y >= ey and y <= ey + h then
      -- Verifica children (elementos mais "profundos" têm prioridade)
      for _, child in ipairs(element.childs) do
        local found = checkElement(child, x, y)
        if found then return found end
      end
      return element
    end
    return nil
  end

  return checkElement(self.rootElement, x, y)
end

return UiController
