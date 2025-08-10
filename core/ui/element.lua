local utils = require "core.utils"

---@class UIElement
local UIElement = {
  absolutePosition = { x = 0, y = 0 },
  absoluteDirty = true, -- Novo flag de cache  lastRenderTime = 0,
  last_float_position = { x = 0, y = 0, width = 0, height = 0 },
  maximized = false,
  minimized = false,
  noPropagate = false,
  target_fps = 60,
  ID = "",
  style = {
    padding         = 0,
    bg              = { 0, 0, 0 },
    fg              = { 1, 1, 1 },
    border          = { 151, 187, 195 },
    border_dragging = { 191, 32, 50 },
    font_size       = 12,
  },
  last_size = {},
  resizable = false,
  resizing = false,
  hasMouseFocus = false,
  isMouseOver = false,
  clickable = false,
  dragable = false,
  lastMouseState = false,
  resizeMode = "right",
  minWidth = 50,
  minHeight = 50,
  name = "BaseComponent",
  dragging = false,
  canvas = nil,
  childs = {},
  childs_render = {},
  rect = { x = 0, y = 0, width = 100, height = 100 }, -- Retângulo de posicionamento
  visible = true,
  dirty = false,
  parent = nil,
  timeSinceLastRender = 0,
  alpha = 1,
  fixedSize = false,
  -- Data | Ter uma tabela de dados para o elemento
  data = nil,
  target = nil,
  texture = nil,
  index = 0,
  render_order = {},
  timeSinceLastDraw = 0,
}
UIElement.__index = UIElement

function UIElement:new(x, y, width, height)
  local self = setmetatable({}, UIElement)
  self.ID = utils.newUUID()
  self.rect = { x = x or 10, y = y or 10, width = width or 100, height = height or 100 }
  -- self.canvas = love.graphics.newCanvas(self.rect.width, self.rect.height)
  self.childs = {}
  -- self.dirty = true

  self.style = utils.deepCopy(UIElement.style)

  return self
end

function UIElement:start()
  local x, y = self:get_absolute_position();
  self.absolutePosition.x = x
  self.absolutePosition.y = y
end

-- Método para obter posição absoluta (considerando hierarquia)
function UIElement:get_absolute_position()
  if not self.parent then
    return self.rect.x, self.rect.y
  end
  local parentX, parentY = self.parent:get_absolute_position()
  -- local parentX, parentY = self.parent.absolutePosition.x, self.parent.absolutePosition.y
  return parentX + self.rect.x, parentY + self.rect.y
end

-- Marca este elemento e todos os pais como necessitando renderização
function UIElement:mark_dirty()
  self.dirty = true

  -- Propaga para os pais (para casos de clipping/overlap)
  -- if self.parent then
  -- self.parent:markDirty()
  -- end

  for _, c in ipairs(self.childs) do
    c:mark_dirty()
  end
end

-- Método base para draw (deve ser sobrescrito pelas classes filhas)
function UIElement:_draw()
end

function UIElement:draw()
  if self.texture then
    self:draw_texture()
    return
  end

  love.graphics.setColor(love.math.colorFromBytes(self.style.bg))
  love.graphics.rectangle("fill", 0, 0, self.rect.width, self.rect.height)
end

function UIElement:draw_texture()
  love.graphics.draw(self.texture, 0, 0, 0, 1, 1, 0, 0)
end

---@param _ number
function UIElement:update(_)
end

function UIElement:add_child(child)
  table.insert(self.childs, child)
  child.parent = self

  table.insert(self.render_order, child.ID)
  self.childs_render[child.ID] = #self.childs

  if child.start then
    child:start()
  end

  self:mark_dirty() -- A interface mudou
  return child
end

function UIElement:bring_to_front()
  if self.parent then
    self.parent.to_front = self
  end
end

function UIElement:is_time_to_render()
  -- local now = love.timer.getTime()
  -- if now - self.lastRenderTime < (1 / self.target_fps) then
  --   return -- Não renderiza se ainda não atingiu o intervalo
  -- end
  -- self.lastRenderTime = now
  return true
end

function UIElement:render()
  if not self.visible or self.alpha <= 0 then return end

  -- if not self:is_time_to_render() then return end

  -- 1. Renderiza no canvas se dirty
  if self.dirty then
    self:startCanvas()

    -- Aplica o alpha global do elemento
    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(1, 1, 1, self.alpha)

    self:draw()
    love.graphics.setColor(r, g, b, a)
    self.dirty = false

    love.graphics.setCanvas()
  end

  -- 2. Desenha o canvas na tela

  -- local x, y = self:getAbsolutePosition()

  local x, y = self:get_absolute_position()
  -- print("Debug2: " .. self.name)
  -- love.graphics.setColor(1, 1, 1, self.alpha) -- Aplica alpha novamente
  love.graphics.draw(self.canvas, x, y)
  -- love.graphics.setColor(1, 1, 1, 1)          -- Reseta para branco sólido

  -- 3. Renderiza filhos
  for _, id in ipairs(self.render_order) do
    local child = self.childs[self.childs_render[id]]
    if child then
      child:render()
    end
  end
end

function UIElement:setCanvas(w, h)
  if self.canvas then self.canvas:release() end
  self.canvas = love.graphics.newCanvas(w, h)
  self.canvas:setFilter('nearest', 'nearest')
end

function UIElement:startCanvas()
  if not self.canvas or
      self.canvas:getWidth() ~= math.floor(self.rect.width) or
      self.canvas:getHeight() ~= math.floor(self.rect.height)
  then
    print("Startando um novo canvas")
    if self.canvas then
      self.canvas:release()
    end

    self.canvas = love.graphics.newCanvas(self.rect.width, self.rect.height)
    self.canvas:setFilter('nearest', 'nearest')
    self.dirty = true
  end

  love.graphics.setLineWidth(1)
  love.graphics.setCanvas({ self.canvas, stencil = true })
  love.graphics.clear(0, 0, 0, 0, true) -- Limpa completamente com alpha 0
  love.graphics.setBlendMode('alpha')
end

function UIElement:updateLayout()
  for _, child in ipairs(self.childs) do
    child:updateLayout()
  end
end

---@param rect Rect
function UIElement:updateRect(rect)
  -- Verifica se as dimensões realmente mudaram
  if self.rect.width ~= rect.width or self.rect.height ~= rect.height then
    -- Libera o canvas existente se as dimensões mudaram
    if self.canvas then
      self.canvas:release()
      self.canvas = nil
    end
  end

  self.rect = rect
  self.dirty = true

  -- TODO: Isso precisa ser reavalido
  -- Marca os pais como dirty para garantir que a hierarquia seja atualizada
  if self.parent then
    self.parent:mark_dirty()
  end
end

---@param x number
---@param y number
function UIElement:updatePosition(x, y)
  self.rect.x = x
  self.rect.y = y
  self:mark_dirty()
end

function UIElement:bindData(data)
  self.data = data
end

---@param mousedata MouseClickData
function UIElement:click(mousedata)
  print(self.name .. ":UIElement:click")
  print(utils.inspect(mousedata))
end

function UIElement:handle_mouse_move()
end

function UIElement:drag_to(mx, my)
  if self.dragOffsetX and self.dragOffsetY and self.parent then
    -- Posição absoluta do pai
    local pAbsX, pAbsY = self.parent:get_absolute_position()
    print("Debug3")

    -- Offset do mouse relativo ao pai
    local localX = mx - pAbsX - self.dragOffsetX
    local localY = my - pAbsY - self.dragOffsetY

    -- Limitar aos limites do pai (com clamp)
    local newX, newY = self:clamp_to_parent(localX, localY)
    self:updatePosition(newX, newY)
  end
end

---@return UIElement
function UIElement:begin_drag(mouseX, mouseY)
  local target = self.drag_taget and self.drag_taget or self

  local ax, ay = target:get_absolute_position()
  print("Debug4")
  target.dragOffsetX = mouseX - ax
  target.dragOffsetY = mouseY - ay
  target.dragging = true
  target:mark_dirty()
  return self
end

function UIElement:endDrag(automatic)
  local target = self.drag_taget and self.drag_taget or self
  target.dragging = false
  target:mark_dirty()
end

function UIElement:isMouseInsideInnerBounds(mx, my)
  local ax, ay = self:get_absolute_position()
  print("Debug5")
  local x1 = ax + 5
  local y1 = ay + 5
  local x2 = ax + self.rect.width - 5
  local y2 = ay + self.rect.height - 5

  return mx > x1 and mx < x2 and my > y1 and my < y2
end

function UIElement:focus_out()
  if self.dragging then
    self:endDrag()
  end
end

function UIElement:resize(w, h)
  if w > self.minWidth then
    self.rect.width = w
  end

  if h > self.minHeight then
    self.rect.height = h
  end

  self:propagateResize()
end

function UIElement:setMinimalSize()
  self.rect.width = self.minWidth
  self.rect.height = self.minHeight
  self:propagateResize()
end

function UIElement:propagateResize()
  for _, child in ipairs(self.childs) do
    if child.watch_resize then
      child:watch_resize()
    end
  end
end

function UIElement:watch_resize()
end

---@return UIElement
function UIElement:start_resize()
  local px, py = love.mouse.getPosition()
  self.resizing = true
  self.resizeStartMouseX = px
  self.resizeStartMouseY = py
  self.resizeStartWidth = self.parent.rect.width
  self.resizeStartHeight = self.parent.rect.height
  return self
end

function UIElement:end_resize()
  self.resizing = false
end

function UIElement:on_mouse_enter()
end

function UIElement:on_mouse_leave()
end

function UIElement:handle_event(event)
  -- print("default handleEvent")
end

function UIElement:debug_box()
  if self and self.debugging then
    if self.rect then
      love.graphics.setColor(0, 0, 0)
      love.graphics.setLineWidth(2)
      if self.debug_rect then
        love.graphics.rectangle("line", 0, 0, self.debug_rect.width, self.debug_rect.height)
        return
      end
      love.graphics.rectangle("line", 0, 0, self.rect.width, self.rect.height)
    end
  end
end

function UIElement:isValidMove(x, y)
  if not self.parent then
    return true -- sem pai = não há limites
  end

  -- Novo canto superior esquerdo
  local newX             = x - (self.dragOffsetX or 0)
  local newY             = y - (self.dragOffsetY or 0)

  -- Dimensões do elemento
  local width            = self.rect.width
  local height           = self.rect.height

  -- Limites do pai
  local parentRect       = self.parent.rect

  -- Verificações: se o novo retângulo do elemento vai ficar DENTRO do pai
  local dentroHorizontal = newX >= 0 and (newX + width) <= parentRect.width
  local dentroVertical   = newY >= 0 and (newY + height) <= parentRect.height

  return dentroHorizontal and dentroVertical
end

function UIElement:clamp_to_parent(x, y)
  local px, py = self.parent:get_absolute_position()
  print("Debug6")
  local pw, ph = self.parent.rect.width, self.parent.rect.height

  local newX = math.max(0, math.min(x, pw - self.rect.width))
  local newY = math.max(0, math.min(y, ph - self.rect.height))

  return newX, newY
end

function UIElement:new_focus_order(child_id)
  for i, v in ipairs(self.render_order) do
    if v == child_id then
      table.remove(self.render_order, i)
      table.insert(self.render_order, child_id) -- último = desenhado por último (acima)
      break
    end
  end
end

---@param event Events
function UIElement:consumeEvent(event, event_data)
end

function UIElement:toggleVisibility(v)
  self.invisible = v
  for _, c in ipairs(self.childs) do
    c:toggleVisibility(v)
  end
end

return UIElement
