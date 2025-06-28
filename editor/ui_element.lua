local ResizeMode = require "editor.enum_resize_mode"

---@enum DirtyFlags
local DirtyFlags = make_enum({
  "Layout",
  "Content",
  "Full",
})

---@class UiElement
---@field childs UiElement[]
---@field markDirty function
---@field parent UiElement | nil
---@field canvas any
---@field rect Rect
---@field dirty boolean
---@field resizeMode string
---@field name string
---@field resizable boolean
---@field draw function
local UiElement = {
  hasMouseFocus = false,
  isMouseOver = false,
  lastMouseState = false,
  resisable = false,
  resizeMode = "right",
  minWidth = 50,
  minHeight = 50,
  name = "BaseComponent",
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
}
UiElement.__index = UiElement

function UiElement:new(x, y, width, height)
  local obj = setmetatable({}, UiElement)
  obj.rect = { x = x or 0, y = y or 0, width = width or 100, height = height or 100 }
  obj.canvas = love.graphics.newCanvas(obj.rect.width, obj.rect.height)
  obj.childs = {}
  obj.dirty = true
  return obj
end

-- Método para obter posição absoluta (considerando hierarquia)
function UiElement:getAbsolutePosition()
  if not self.parent then
    return self.rect.x, self.rect.y
  end
  local parentX, parentY = self.parent:getAbsolutePosition()
  return parentX + self.rect.x, parentY + self.rect.y
end

-- Marca este elemento e todos os pais como necessitando renderização
---@param flag DirtyFlags
function UiElement:markDirty(flag)
  if flag ~= nil then
    if flag == DirtyFlags.Layout then
    end

    if flag == DirtyFlags.Content then
    end

    if flag == DirtyFlags.Full then
    end
  end


  self.dirty = true

  -- Propaga para os pais (para casos de clipping/overlap)
  if self.parent then
    self.parent:markDirty()
  end
end

-- Método base para draw (deve ser sobrescrito pelas classes filhas)
function UiElement:draw()
  local x, y = self:getAbsolutePosition()
  love.graphics.rectangle("line", x, y, self.rect.width, self.rect.height)
end

-- Método para atualização (lógica)
function UiElement:update(dt)
  -- Atualiza todos os children
  for _, child in ipairs(self.childs) do
    child:update(dt)
  end
end

-- Adiciona um child a este elemento
function UiElement:addChild(child)
  table.insert(self.childs, child)
  child.parent = self
  self:markDirty() -- A interface mudou
  return child
end

-- Remove um child
function UiElement:removeChild(child)
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

function UiElement:render()
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
    child:render()
  end
end

function UiElement:startCanvas()
  if self.canvas == nil then
    self.canvas = love.graphics.newCanvas(self.rect.width, self.rect.height)
    -- Configura o canvas para limpar completamente
    self.canvas:setFilter('nearest', 'nearest')
  end

  love.graphics.setCanvas({ self.canvas, stencil = true })
  love.graphics.clear(0, 0, 0, 0, true) -- Limpa completamente com alpha 0
  love.graphics.setBlendMode('alpha', 'premultiplied')
end

function UiElement:updateLayout()
  for _, child in ipairs(self.childs) do
    child:updateLayout()
  end
end

---@param rect Rect
function UiElement:updateRect(rect)
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
    self.parent:markDirty(DirtyFlags.Layout)
  end
end

function UiElement:manageMemory()
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

function UiElement:freeResources()
  if self.canvas then
    self.canvas:release()
  end

  for _, child in ipairs(self.childs) do
    child:freeResources()
  end
end

function UiElement:drawText(text, x, y)
  -- 1. Configurações ótimas para texto claro
  local oldFont = love.graphics.getFont()

  -- 2. Crie uma fonte dedicada se necessário
  if not self.uiFont then
    self.uiFont = love.graphics.newFont(12) -- Tamanho adequado
    self.uiFont:setFilter("nearest", "nearest")
  end

  -- 3. Aplica configurações
  love.graphics.setFont(self.uiFont)
  love.graphics.setColor(1, 1, 1, 1) -- Branco sólido

  -- 4. Renderiza o texto com offsets inteiros para evitar borrão
  local ix, iy = math.floor(x), math.floor(y)
  love.graphics.print(text, ix, iy)

  -- 5. Restaura configurações
  love.graphics.setFont(oldFont)
end

return UiElement
