local UiElement = require "editor.ui_element"
local ResizeMode = require "editor.enum_resize_mode"

---@class UiHandler
---@field rootElement UiElement | nil
---@field uiOutOffSizeElement UiElement | nil
---@field addElement function
---@field stopped boolean
local UiHandler = {
  rootElement = nil,
  uiOutOffSizeElement = nil,
  stopped = false,
}
UiHandler.__index = UiHandler

function UiHandler:new()
  local obj = setmetatable({}, UiHandler)
  obj.elementOnMouseFocus = nil
  obj.previousMouseFocus = nil

  obj.uiOutOffSizeElement = newUiOutOffSize()

  return obj
end

function newUiOutOffSize()
  local uiOutOffSizeElement = UiElement:new(0, 0, love.graphics.getWidth(), love.graphics.getHeight())
  uiOutOffSizeElement.name = "OutOffSizeElement"
  uiOutOffSizeElement.draw = function(_)
    local w, h = GetWindowSize()
    love.graphics.clear()
    -- love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 0, 0, w, h)

    local font = love.graphics.newFont(42)
    love.graphics.setFont(font)

    -- Texto que será exibido
    local text = "ERRO"

    -- Obtém as dimensões do texto
    local textWidth = font:getWidth(text)
    local textHeight = font:getHeight()

    -- Calcula a posição centralizada
    local x = (w - textWidth) / 2
    local y = (h - textHeight) / 2

    -- Desenha o texto
    love.graphics.setColor(1, 0, 0) -- Vermelho
    love.graphics.print(text, x, y)
  end
  return uiOutOffSizeElement
end

-- Atualiza toda a UI
function UiHandler:update(dt)
  -- self.rootElement:update(dt)

  -- local deepestChild = self:getDeepestChildAtPosition(x, y)
  if self.elementOnMouseFocus == nil then return end

  self.elementOnMouseFocus:update(dt)
end

---@param mouseData  MouseClickData
function UiHandler:handleMouseClick(mouseData)
  if self.stopped then return end

  local focus = self:handleMouseMove(mouseData.x, mouseData.y)

  if focus ~= nil and focus.click then
    if mouseData.pressed then
      focus:click(mouseData)
    else
      focus:click(mouseData)
    end
  end
end

function UiHandler:handleMouseMove(x, y)
  if self.stopped then return end
  local deepestChild = self:getDeepestChildAtPosition(x, y)

  -- Atualiza o foco atual
  self:updateFocus(deepestChild)

  -- Retorna o elemento com foco (útil para outros eventos)
  return deepestChild
end

function UiHandler:getDeepestChildAtPosition(x, y)
  local function findDeepest(element)
    if not element.visible or element.alpha <= 0 then
      return nil
    end

    -- Garante que ex e ey são números
    local absX, absY = element:getAbsolutePosition()
    local ex, ey = tonumber(absX), tonumber(absY)
    local w, h = tonumber(element.rect.width), tonumber(element.rect.height)

    -- Verificação adicional de tipos
    if type(ex) ~= "number" or type(ey) ~= "number" or
        type(w) ~= "number" or type(h) ~= "number" then
      print("Erro: Valores inválidos para elemento " .. tostring(element.name))
      print("ex:", ex, "ey:", ey, "w:", w, "h:", h)
      return nil
    end

    -- Verifica se o ponto está dentro do elemento (agora seguro)
    if x >= ex and x <= ex + w and y >= ey and y <= ey + h then
      -- Procura por filhos mais profundos (ordem inversa)
      for i = #element.childs, 1, -1 do
        local child = element.childs[i]
        local found = findDeepest(child)
        if found then
          return found
        end
      end
      return element
    end
    return nil
  end

  return findDeepest(self.rootElement)
end

function UiHandler:updateFocus(newFocus)
  if self.stopped then return end
  -- Se o foco não mudou, não faz nada
  if self.elementOnMouseFocus == newFocus then
    return
  end
  -- Remove o foco do elemento anterior
  if self.elementOnMouseFocus then
    self.elementOnMouseFocus:markDirty()
    self.elementOnMouseFocus.hasMouseFocus = false
    self.elementOnMouseFocus.isMouseOver = false
    if self.elementOnMouseFocus.onMouseLeave then
      self.elementOnMouseFocus:onMouseLeave()
    end
  end


  -- Atribui o novo foco
  self.previousMouseFocus = self.elementOnMouseFocus
  self.elementOnMouseFocus = newFocus

  -- Aplica o novo foco
  if newFocus then
    newFocus.hasMouseFocus = true
    newFocus.isMouseOver = true
    if newFocus.onMouseEnter then
      newFocus:onMouseEnter()
    end

    -- Propaga para cima na hierarquia (opcional)
    -- self:propagateMouseOver(newFocus)
    newFocus:markDirty()
  end
end

-- Marca todos os pais como "mouse over" até a raiz
function UiHandler:propagateMouseOver(element)
  local parent = element.parent
  while parent do
    parent.isMouseOver = true
    parent = parent.parent
  end
end

function UiHandler:resize()
  local w, h = love.graphics.getDimensions()

  if w < 600 or h < 400 then
    self.stopped = true
    return
  else
    self.stopped = false
  end

  -- Atualiza o root element
  self.rootElement:updateRect({ x = 0, y = 0, width = w, height = h })
  self.uiOutOffSizeElement:updateRect({ x = 0, y = 0, width = w, height = h })

  -- Encontra os painéis de referência
  local left_panel, center_panel, right_panel

  for _, child in ipairs(self.rootElement.childs) do
    if child.resizeMode == ResizeMode.LEFT then
      left_panel = child
    elseif child.resizeMode == ResizeMode.RIGHT then
      right_panel = child
    elseif child.resizeMode == ResizeMode.HORIZONTAL_CENTER then
      center_panel = child
    end
  end

  -- Redimensiona os painéis de forma relativa
  if left_panel and right_panel then
    -- Atualiza painel esquerdo
    left_panel:updateRect({
      x = 0,
      y = 0,
      width = left_panel.rect.width,
      height = h
    })

    -- Atualiza painel direito
    right_panel:updateRect({
      x = w - right_panel.rect.width,
      y = 0,
      width = right_panel.rect.width,
      height = h
    })

    -- Se existir painel central, ajusta entre os outros dois
    if center_panel then
      center_panel:updateRect({
        x = left_panel.rect.width,
        y = 0,
        width = w - left_panel.rect.width - right_panel.rect.width,
        height = h
      })
    end
  end
end

-- Renderiza toda a UI
function UiHandler:render()
  if self.stopped then
    self.uiOutOffSizeElement:render()
  else
    self.rootElement:render()
  end
end

-- Adiciona um elemento na raiz
function UiHandler:addElement(element)
  return self.rootElement:addChild(element)
end

-- Remove um elemento da raiz
function UiHandler:removeElement(element)
  return self.rootElement:removeChild(element)
end

-- Função para encontrar elemento sob o mouse (útil para eventos)
function UiHandler:getElementAt(x, y)
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

function UiHandler:updateLayout()
  self.rootElement:updateLayout()
end

function UiHandler:markDirty(flag)
  self.rootElement:markDirty(flag)
end

return UiHandler
