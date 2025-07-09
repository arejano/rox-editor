---@class UIElement
---@field ID string
---@field childs UIElement[]
---@field markDirty function
---@field startResize function
---@field endResize function
---@field onMouseLeave function
---@field handleEvent function
---@field parent UIElement | nil
---@field canvas any
---@field rect Rect
---@field dirty boolean
---@field resizeMode string
---@field name string
---@field resizable boolean
---@field draw function
---@field minWidth number
---@field minHeight number
---@field isClickable boolean
---@field isDragable boolean
---@field dragging boolean
---@field dragOffsetX number
---@field dragOffsetY number
---@field resizing boolean
---@field style ElementStyle
---@field debugging ElementStyle
---@field debug_rect Rect
---@field drag_taget UIElement
---@field isResizer boolean
---@field resizer_target UIElement
---@field transpass boolean
---@field hasMouseFocus boolean
---@field isMouseOver boolean
---@field target UIElement | nil
---@field texture any
---@field index number
---@field to_front UIElement
local UIElement = {
  ID = "",
  style = {
    padding         = 0,
    bg              = { 0, 0, 0 },
    fg              = { 1, 1, 1 },
    border          = { 151, 187, 195 },
    border_dragging = { 191, 32, 50 },
    font_size       = 12,
  },
  resizable = false,
  resizing = false,
  hasMouseFocus = false,
  isMouseOver = false,
  isClickable = false,
  isDragable = false,
  lastMouseState = false,
  resizeMode = "right",
  minWidth = 50,
  minHeight = 50,
  name = "BaseComponent",
  dragging = false,
  canvas = nil,
  childs = {},
  rect = { x = 0, y = 0, width = 100, height = 100 }, -- Retângulo de posicionamento
  visible = true,
  dirtyFlags = {
    layout = true,
    content = true,
    full = true,
  },
  dirty = true,
  parent = nil,
  timeSinceLastRender = 0,
  alpha = 1,
  fixedSize = false,
  -- Data | Ter uma tabela de dados para o elemento
  data = nil,
  target = nil,
  texture = nil,
  index = 0,
  to_front = nil,
}
UIElement.__index = UIElement

function UIElement:new(x, y, width, height)
  local self = {}
  self.ID = newUUID()
  self.rect = { x = x or 0, y = y or 0, width = width or 100, height = height or 100 }
  self.canvas = love.graphics.newCanvas(self.rect.width, self.rect.height)
  self.childs = {}
  self.dirty = true
  return setmetatable(self, UIElement)
end

function UIElement:start()
end

-- Método para obter posição absoluta (considerando hierarquia)
function UIElement:getAbsolutePosition()
  if not self.parent then
    return self.rect.x, self.rect.y
  end
  local parentX, parentY = self.parent:getAbsolutePosition()
  return parentX + self.rect.x, parentY + self.rect.y
end

function UIElement:forceRender()
  self:markDirty()
end

-- Marca este elemento e todos os pais como necessitando renderização
---@param flag DirtyFlags
function UIElement:markDirty()
  self.dirty = true

  -- Propaga para os pais (para casos de clipping/overlap)
  -- if self.parent then
  -- self.parent:markDirty()
  -- end

  for i, c in ipairs(self.childs) do
    c:markDirty()
  end
end

-- Método base para draw (deve ser sobrescrito pelas classes filhas)
function UIElement:draw()
  if self.texture then
    self:drawTexture()
    return
  end

  love.graphics.setColor(love.math.colorFromBytes(self.style.border))
  love.graphics.rectangle("line", 0, 0, self.rect.width, self.rect.height)
end

function UIElement:drawTexture()
  love.graphics.draw(self.texture, 0, 0, 0, 1, 1, 0, 0)
end

-- Método para atualização (lógica)
function UIElement:update(dt)
  -- self.timeSinceLastRender = self.timeSinceLastRender + dt
  -- for _, child in ipairs(self.childs) do
  --   child:update(dt)
  -- end
end

function UIElement:teste(dt)
  -- Atualiza todos os children
end

-- Adiciona um child a este elemento
function UIElement:addChild(child)
  table.insert(self.childs, child)
  child.parent = self
  self.to_front = child

  if child.start then
    child:start()
  end

  self:markDirty() -- A interface mudou
  return child
end

function UIElement:bringToFront()
  if self.parent then
    self.parent.to_front = self
  end
end

-- Remove um child
function UIElement:removeChild(child)
  for i, c in ipairs(self.childs) do
    if c == child then
      table.remove(self.childs, i)
      child.parent = nil
      self:markDirty()
      return true
    end
  end
  return false
end

function UIElement:render()
  if not self.visible or self.alpha <= 0 then return end

  -- Recria o canvas se necessário (tamanho mudou ou não existe)
  if not self.canvas or
      self.canvas:getWidth() ~= self.rect.width or
      self.canvas:getHeight() ~= self.rect.height then
    if self.canvas then self.canvas:release() end
    self.canvas = love.graphics.newCanvas(self.rect.width, self.rect.height)
    self.dirty = true -- Força redesenho
  end

  -- 1. Renderiza no canvas se dirty
  if self.dirty then
    self:startCanvas()

    -- Aplica o alpha global do elemento
    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(1, 1, 1, self.alpha)
    self:draw()
    self:debug_box()
    love.graphics.setColor(r, g, b, a)

    love.graphics.setCanvas()
    self.dirty = false
  end

  -- 2. Desenha o canvas na tela
  local x, y = self:getAbsolutePosition()
  love.graphics.setColor(1, 1, 1, self.alpha) -- Aplica alpha novamente
  love.graphics.draw(self.canvas, x, y)
  love.graphics.setColor(1, 1, 1, 1)          -- Reseta para branco sólido

  -- 3. Renderiza filhos
  for _, child in ipairs(self.childs) do
    if self.to_front then
      if child.ID ~= self.to_front.ID then
        child:render()
      end
    end
  end

  if self.to_front then
    self.to_front:render()
  end
end

function UIElement:setCanvas(w, h)
  if self.canvas then self.canvas:release() end
  self.canvas = love.graphics.newCanvas(w, h)
  self.canvas:setFilter('nearest', 'nearest')
end

function UIElement:startCanvas()
  if self.canvas == nil then
    self.canvas = love.graphics.newCanvas(self.rect.width, self.rect.height)
    -- Configura o canvas para limpar completamente
    self.canvas:setFilter('nearest', 'nearest')
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
  self.dirtyFlags.full = true

  -- Marca os pais como dirty para garantir que a hierarquia seja atualizada
  if self.parent then
    self.parent:markDirty()
  end
end

---@param w number
---@param h number
function UIElement:updateSize(w, h)
  self.rect.width = w
  self.rect.height = h

  if self.parent then
    self.parent:markDirty()
  end

  self:propagateResize()
end

---@param w number
---@param h number
function UIElement:updatePosition(x, y)
  self.rect.x = x
  self.rect.y = y
  self:markDirty()
end

function UIElement:manageMemory()
  -- Para elementos fora da tela/inativos
  if not self.visible or self.alpha == 0 then
    if self.canvas then
      self.canvas:release()
      self.canvas = nil
      self.dirty = true -- Força rerrenderização quando voltar
    end
  end

  -- Para elementos que não mudam há muito tempo
  if not self.dirty and self.timeSinceLastRender > 60 then
    self:freeResources()
  end

  -- Propaga para filhos
  for _, child in ipairs(self.childs) do
    child:manageMemory()
  end
end

function UIElement:freeResources()
  if self.canvas then
    self.canvas:release()
  end

  for _, child in ipairs(self.childs) do
    child:freeResources()
  end
end

function UIElement:bindData(data)
  self.data = data
end

function UIElement:click()
  print("Click padrao do elemento")
end

function UIElement:handleMouseMove()
end

function UIElement:dragTo(x, y)
  if self.dragOffsetX and self.dragOffsetY then
    local newX = x - self.dragOffsetX
    local newY = y - self.dragOffsetY

    self:updatePosition(newX, newY)
  end
end

---@return UIElement
function UIElement:beginDrag(mouseX, mouseY)
  local target = self.drag_taget and self.drag_taget or self

  local ax, ay = target:getAbsolutePosition()

  target.dragOffsetX = mouseX - ax
  target.dragOffsetY = mouseY - ay
  target.dragging = true
  target:markDirty()
  return self
end

function UIElement:endDrag()
  local target = self.drag_taget and self.drag_taget or self

  target.dragging = false
  target:markDirty()
end

function UIElement:isMouseInsideInnerBounds(mx, my)
  local ax, ay = self:getAbsolutePosition()
  local x1 = ax + 5
  local y1 = ay + 5
  local x2 = ax + self.rect.width - 5
  local y2 = ay + self.rect.height - 5

  return mx > x1 and mx < x2 and my > y1 and my < y2
end

function UIElement:focusOut()
  self:endDrag()
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

function UIElement:propagateResize()
  for i, child in ipairs(self.childs) do
    if child.watch_resize then
      child:watch_resize()
    end
  end
end

function UIElement:watch_resize()
end

---@return UIElement
function UIElement:startResize()
  local px, py = love.mouse.getPosition()
  self.resizing = true
  self.resizeStartMouseX = px
  self.resizeStartMouseY = py
  self.resizeStartWidth = self.parent.rect.width
  self.resizeStartHeight = self.parent.rect.height
  return self
end

function UIElement:endResize()
  self.resizing = false
end

function UIElement:onMouseEnten()
end

function UIElement:onMouseLeave()
end

function UIElement:handleEvent(event)
  print("default handleEvent")
  print(inspect(event))
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

return UIElement
