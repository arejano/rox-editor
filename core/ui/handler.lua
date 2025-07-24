local UIElement = require "core.ui.element"
local utils = require "core.utils"

---@class UIHandler
---@field rootElement UIElement | nil
---@field stopped boolean
---@field elementOnMouseFocus UIElement
---@field elementOnDragging UIElement | nil
---@field elementOnResizing UIElement | nil
local UIHandler = {
  rootElement = nil,
  stopped = false,
  elementOnMouseFocus = nil,
  elementOnDragging = nil,
  elementOnResizing = nil,
  minWidth = 200,
  minHeight = 200,
}
UIHandler.__index = UIHandler

function UIHandler:new()
  local obj = setmetatable({}, UIHandler)
  obj.elementOnMouseFocus = nil
  obj.previousMouseFocus = nil


  return obj
end

---------------------------------------------------------Update
function UIHandler:update(dt)
  -- self.rootElement:update(dt)
  -- local deepestChild = self:getDeepestChildAtPosition(x, y)
  -- if self.elementOnMouseFocus == nil then return end
  -- self.elementOnMouseFocus:update(dt)

  -- Para childs que
end

function UIHandler:cancelDragAndResize(relese)
  if relese then
    if self.elementOnResizing then
      self.elementOnResizing:endResize()
      self.elementOnResizing = nil
    end

    if self.elementOnDragging then
      self.elementOnDragging:endDrag()
      self.elementOnDragging = nil
    end
  end
end

---------------------------------------------------------Mouse
---@param mousedata  MouseClickData
function UIHandler:handleMouseClick(mousedata)
  print(mousedata.pressed and "--pressed" or "--released" .. "-----------------------------")

  if self.stopped then return end

  local focus = self.elementOnMouseFocus



  -- Cancel Dragging and Resize
  self:cancelDragAndResize(mousedata.release)

  if focus and focus.transpass then
    print("WOW2")
    while focus.transpass do
      focus = focus.parent
    end
  end

  if focus.parent and mousedata.pressed then
    print("WOW3")
    focus.parent:newFocusOrder(focus.ID)
  end

  -- Resizing
  if focus ~= nil and focus.resizer_target then
    print("WOW4")
    if mousedata.pressed then
      print("WOW5")
      self.elementOnResizing = focus:startResize()
    end
    return
  end

  -- Dragging
  if focus ~= nil and focus.dragable and not focus.minimized then
    print("WOW6")
    if mousedata.pressed then
      print("WOW7")
      self.elementOnDragging = focus:beginDrag(mousedata.x, mousedata.y)
    end
    return
  end

  -- Send click to focus
  if focus ~= nil and focus.click and focus.clickable then
    print("WOW8")
    focus:click(mousedata)
  end
end

function UIHandler:handleMouseMove(x, y)
  if self.elementOnDragging or self.elementOnResizing then
    return
  end

  local deepestChild = self:getDeepestChildAtPosition(x, y)

  -- Atualiza o foco atual
  self:updateFocus(deepestChild)

  -- Retorna o elemento com foco (útil para outros eventos)
  return deepestChild
end

function UIHandler:getDeepestChildAtPosition(x, y)
  local function findDeepest(element)
    if not element.visible or element.alpha <= 0 then
      return nil
    end

    -- Posição absoluta
    local absX, absY = element:getAbsolutePosition()
    local ex, ey = tonumber(absX), tonumber(absY)
    local w, h = tonumber(element.rect.width), tonumber(element.rect.height)

    if type(ex) ~= "number" or type(ey) ~= "number" or type(w) ~= "number" or type(h) ~= "number" then
      print("Erro: Valores inválidos para elemento " .. tostring(element.name))
      return nil
    end

    -- Se o ponto (x, y) está dentro do elemento
    if x >= ex and x <= ex + w and y >= ey and y <= ey + h then
      -- Verifica filhos pela ordem de renderização (de cima para baixo)
      if element.render_order then
        for i = #element.render_order, 1, -1 do
          local child_id = element.render_order[i]
          local child_idx = element.childs_render and element.childs_render[child_id]
          local child = child_idx and element.childs[child_idx]

          if child then
            local found = findDeepest(child)
            if found then
              return found
            end
          end
        end
      else
        -- fallback (se não houver render_order)
        for i = #element.childs, 1, -1 do
          local found = findDeepest(element.childs[i])
          if found then
            return found
          end
        end
      end

      return element
    end

    return nil
  end

  return findDeepest(self.rootElement)
end

function UIHandler:updateFocus(newFocus)
  -- Se o foco não mudou, não faz nada
  if self.elementOnMouseFocus == newFocus then
    return
  end

  -- Remove o foco do elemento anterior
  if self.elementOnMouseFocus then
    self.elementOnMouseFocus:focusOut()
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
    self:propagateMouseOver(newFocus)
    newFocus:markDirty()
  end
end

-- Marca todos os pais como "mouse over" até a raiz
function UIHandler:propagateMouseOver(element)
  local parent = element.parent
  while parent do
    parent.isMouseOver = true
    parent = parent.parent
  end
end

--------------------------------------------------------- Resize
---@param w number
---@param h number
function UIHandler:resize(w, h)
  self.stopped = utils.isInvalidResize(w, h, self.minWidth, self.minHeight)
  if self.stopped then return end

  -- Atualiza o root element
  self.rootElement:updateRect({ x = 0, y = 0, width = w, height = h })
  self.rootElement:resize(w, h)
end

-- Renderiza toda a UI
function UIHandler:render()
  if self.stopped then return end

  self.rootElement:render()
  self:inspect()
end

function UIHandler:inspect()
  -- local root_childs = self.rootElement:getChildIds()

  -- for i, id in ipairs(root_childs) do
  --   love.graphics.print(id, 10, 20 * i)
  -- end
end

-- Remove um elemento da raiz
function UIHandler:removeElement(element)
  return self.rootElement:removeChild(element)
end

-- Função para encontrar elemento sob o mouse (útil para eventos)
function UIHandler:getElementAt(x, y)
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

function UIHandler:updateLayout()
  self.rootElement:updateLayout()
end

function UIHandler:mouseMoved(mousedata)
  local focus = self:handleMouseMove(mousedata.x, mousedata.y)
  local dragging = self.elementOnDragging
  local resizing = self.elementOnResizing

  if dragging then
    local mx, my = love.mouse.getPosition()
    if dragging.drag_taget then
      -- dragging.drag_taget:dragTo(mx, my)
    else
      dragging:dragTo(mx, my)
    end
    return
  end

  if resizing then
    if resizing.resizer_target then
      resizing:resizeTarget()
    else
      print("Nao existe elemento para redimennsionar")
    end
    return
  end

  if self.elementOnMouseFocus then
    self.elementOnMouseFocus:handleMouseMove();
  end
end

-- function UIHandler:getFocusedElement()
--   local x, y = love.mouse.getPosition()
--   local focusedElement = self:handleMouseMove(x, y)
--   -- Você pode adicionar lógica adicional aqui
--   if focusedElement then
--     local cursor = self:cursorByState(focusedElement)
--     if cursor then
--       love.mouse.setCursor(love.mouse.getSystemCursor(cursor))
--     else
--       love.mouse.setCursor()
--     end
--   end
--   return focusedElement
-- end

---@param element UiElement
function UIHandler:cursorByState(element)
  if self.elementOnResizing then
    return 'sizenwse'
  end


  if self.elementOnDragging or element.dragging then
    return 'hand'
  end

  if element.clickable then
    return 'hand'
  else
    return nil
  end
end

return UIHandler
