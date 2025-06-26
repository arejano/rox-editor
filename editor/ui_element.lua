local UiElement = {
  childs = {},
  rect = { x = 0, y = 0, width = 100, height = 100 }, -- Retângulo de posicionamento
  visible = true,
  dirty = true,                                       -- Flag para renderização seletiva
  parent = nil
}
UiElement.__index = UiElement

function UiElement:new(x, y, width, height)
  local self = setmetatable({}, UiElement)
  self.rect = { x = x or 0, y = y or 0, width = width or 100, height = height or 100 }
  self.childs = {}
  self.dirty = true
  return self
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
function UiElement:markDirty()
  self.dirty = true

  -- Propaga para os pais (para casos de clipping/overlap)
  if self.parent then
    self.parent:markDirty()
  end
end

-- Método base para draw (deve ser sobrescrito pelas classes filhas)
function UiElement:draw()
  -- Implementação básica apenas para debug
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
  self:markDirty()   -- A interface mudou
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

-- Renderiza este elemento e seus children se necessário
function UiElement:render()
  if not self.visible then return end

  -- if self.dirty then
    self:draw()
    self.dirty = false

    -- Marca os children como dirty para garantir consistência
    for _, child in ipairs(self.childs) do
      child.dirty = true
    end
  -- end

  -- Renderiza children (mesmo se não dirty, pois podem ter mudado posição)
  for _, child in ipairs(self.childs) do
    child:render()
  end
end

return UiElement
