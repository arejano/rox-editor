local utils = require "core.utils"

---@class UIHandler
---@field rootElement UIElement | nil
---@field stopped boolean
---@field elementOnMouseFocus UIElement | nil
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

function UIHandler:cancel_drag_and_resize(relese)
  if relese then
    if self.elementOnResizing then
      self.elementOnResizing:end_resize()
      self.elementOnResizing = nil
    end

    if self.elementOnDragging then
      self.elementOnDragging:endDrag()
      self.elementOnDragging = nil
    end
  end
end

---@param mousedata  MouseClickData
function UIHandler:handle_mouse_click(mousedata)
  print(mousedata.pressed and "--pressed" or "--released" .. "-----------------------------")

  if self.stopped then return end

  local focus = self.elementOnMouseFocus

  -- Cancel Dragging and Resize
  self:cancel_drag_and_resize(mousedata.release)

  if focus and focus.transpass then
    print("WOW2")
    while focus.transpass do
      focus = focus.parent
    end
  end

  if focus and focus.parent and mousedata.pressed then
    print("WOW3")
    focus.parent:new_focus_order(focus.ID)
  end

  -- Resizing
  if focus ~= nil and focus.resizer_target then
    print("WOW4")
    if mousedata.pressed then
      print("WOW5")
      self.elementOnResizing = focus:start_resize()
    end
    return
  end

  -- Dragging
  if focus ~= nil and focus.dragable and not focus.minimized then
    print("WOW6")
    if mousedata.pressed then
      print("WOW7")
      self.elementOnDragging = focus:begin_drag(mousedata.x, mousedata.y)
    end
    return
  end

  -- Send click to focus
  if focus ~= nil and focus.click and focus.clickable then
    print("WOW8")
    focus:click(mousedata)
  end
end

function UIHandler:handle_mouse_move(x, y)
  if self.elementOnDragging or self.elementOnResizing then
    return
  end

  local deepestChild = self:get_deepest_child_at_position(x, y)

  -- Atualiza o foco atual
  self:update_focus(deepestChild)

  -- Retorna o elemento com foco (útil para outros eventos)
  return deepestChild
end

function UIHandler:get_deepest_child_at_position(x, y)
  local function find_deepest(element)
    if not element.visible or element.alpha <= 0 then
      return nil
    end

    -- Posição absoluta
    local absX, absY = element:get_absolute_position()
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
            local found = find_deepest(child)
            if found then
              return found
            end
          end
        end
      else
        -- fallback (se não houver render_order)
        for i = #element.childs, 1, -1 do
          local found = find_deepest(element.childs[i])
          if found then
            return found
          end
        end
      end

      return element
    end

    return nil
  end

  return find_deepest(self.rootElement)
end

function UIHandler:update_focus(newFocus)
  -- Se o foco não mudou, não faz nada
  if self.elementOnMouseFocus == newFocus then
    return
  end

  -- Remove o foco do elemento anterior
  if self.elementOnMouseFocus then
    self.elementOnMouseFocus:focus_out()
    self.elementOnMouseFocus.hasMouseFocus = false
    self.elementOnMouseFocus.isMouseOver = false
    if self.elementOnMouseFocus.on_mouse_leave then
      self.elementOnMouseFocus:on_mouse_leave()
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
    -- self:propagate_mouse_over(newFocus)
    newFocus:mark_dirty()
  end
end

-- Marca todos os pais como "mouse over" até a raiz
function UIHandler:propagate_mouse_over(element)
  -- local parent = element.parent
  -- while parent do
  -- parent.isMouseOver = true
  -- parent = parent.parent
  -- end
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
end

-- Função para encontrar elemento sob o mouse (útil para eventos)
function UIHandler:get_element_at(x, y)
  local function checkElement(element, x, y)
    local ex, ey = element:get_absolute_position()
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

function UIHandler:mouse_moved(mousedata)
  local focus = self:handle_mouse_move(mousedata.x, mousedata.y)
  local dragging = self.elementOnDragging
  local resizing = self.elementOnResizing

  if dragging then
    local mx, my = love.mouse.getPosition()
    if dragging.drag_taget then
      -- dragging.drag_taget:dragTo(mx, my)
    else
      dragging:drag_to(mx, my)
    end
    return
  end

  -- if resizing then
  --   if resizing.resizer_target then
  --     resizing:resizeTarget()
  --   else
  --     print("Nao existe elemento para redimennsionar")
  --   end
  --   return
  -- end

  if self.elementOnMouseFocus then
    self.elementOnMouseFocus:handle_mouse_move();
  end
end

return UIHandler
