local utils    = require("core.utils")
local bit      = require("bit")

local Octree   = {}
Octree.__index = Octree

-- Cria uma nova instância de Octree
function Octree.new(bounds, max_depth, capacity)
  return setmetatable({
    bounds = bounds, -- { x, y, z, width, height, depth }
    depth = 0,
    max_depth = max_depth or 5,
    capacity = capacity or 8,
    objects = {},
    children = nil
  }, Octree)
end

-- Verifica se uma entidade cabe dentro de um volume
local function aabb_intersects(a, b)
  return not (
    a.x + a.width < b.x or a.x > b.x + b.width or
    a.y + a.height < b.y or a.y > b.y + b.height or
    a.z + a.depth < b.z or a.z > b.z + b.depth
  )
end

-- Subdivide o nó atual em 8 octantes
function Octree:subdivide()
  self.children = {}
  local x, y, z = self.bounds.x, self.bounds.y, self.bounds.z
  local hw, hh, hd = self.bounds.width / 2, self.bounds.height / 2, self.bounds.depth / 2

  for i = 0, 7 do
    local offset_x = bit.band(i, 1) ~= 0 and hw or 0
    local offset_y = bit.band(i, 2) ~= 0 and hh or 0
    local offset_z = bit.band(i, 4) ~= 0 and hd or 0

    table.insert(self.children, Octree.new({
      x = x + offset_x,
      y = y + offset_y,
      z = z + offset_z,
      width = hw,
      height = hh,
      depth = hd
    }, self.max_depth, self.capacity))
    self.children[#self.children].depth = self.depth + 1
  end
end

-- Tenta inserir uma entidade na octree
function Octree:insert(entity)
  local bounds = {
    x = entity.position.x,
    y = entity.position.y,
    z = entity.position.z,
    width = entity.size.width,
    height = entity.size.height,
    depth = entity.size.depth
  }

  if not aabb_intersects(self.bounds, bounds) then
    return false
  end

  if not self.children and #self.objects < self.capacity or self.depth >= self.max_depth then
    table.insert(self.objects, entity)
    return true
  end

  if not self.children then
    self:subdivide()
  end

  for _, child in ipairs(self.children) do
    if child:insert(entity) then
      return true
    end
  end

  table.insert(self.objects, entity)
  return true
end

-- Consulta por objetos que colidem com a área alvo
function Octree:query(area, found)
  found = found or {}

  if not aabb_intersects(self.bounds, area) then
    return found
  end

  for _, obj in ipairs(self.objects) do
    local bounds = {
      x = obj.position.x,
      y = obj.position.y,
      z = obj.position.z,
      width = obj.size.width,
      height = obj.size.height,
      depth = obj.size.depth
    }
    if aabb_intersects(bounds, area) then
      table.insert(found, obj)
    end
  end

  if self.children then
    for _, child in ipairs(self.children) do
      child:query(area, found)
    end
  end

  return found
end

-- Remove um objeto da árvore
function Octree:remove(entity)
  for i, obj in ipairs(self.objects) do
    if obj.id == entity.id then
      table.remove(self.objects, i)
      return true
    end
  end

  if self.children then
    for _, child in ipairs(self.children) do
      if child:remove(entity) then
        return true
      end
    end
  end

  return false
end

-- Atualiza entidades com dirty flag
function Octree:update_dirty(dirty_entities)
  for _, entity in pairs(dirty_entities) do
    self:remove(entity)
    self:insert(entity)
  end
end

-- Depuração: imprime estrutura da árvore
function Octree:print(level)
  level = level or 0
  print(string.rep(" ", level * 2) .. "Depth " .. self.depth .. ", objects: " .. #self.objects)
  if self.children then
    for _, child in ipairs(self.children) do
      child:print(level + 1)
    end
  end
end

return Octree
