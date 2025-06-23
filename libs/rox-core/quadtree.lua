local quadtree = {}
quadtree.__index = quadtree

function quadtree.new(bounds, capacity)
  local self = setmetatable({}, quadtree)
  self.bounds = bounds -- {x, y, width, height}
  self.capacity = capacity or 4
  self.objects = {}
  self.divided = false
  return self
end

function quadtree:subdivide()
  local x, y, w, h = self.bounds.x, self.bounds.y, self.bounds.width / 2, self.bounds.height / 2

  self.northeast = quadtree.new({ x = x + w, y = y, width = w, height = h }, self.capacity)
  self.northwest = quadtree.new({ x = x, y = y, width = w, height = h }, self.capacity)
  self.southeast = quadtree.new({ x = x + w, y = y + h, width = w, height = h }, self.capacity)
  self.southwest = quadtree.new({ x = x, y = y + h, width = w, height = h }, self.capacity)

  self.divided = true
end

function quadtree:insert(obj)
  if not self:contains(obj) then return false end

  if #self.objects < self.capacity and not self.divided then
    table.insert(self.objects, obj)
    return true
  end

  if not self.divided then
    self:subdivide()
  end

  return (self.northeast:insert(obj) or
    self.northwest:insert(obj) or
    self.southeast:insert(obj) or
    self.southwest:insert(obj))
end

function quadtree:remove(obj)
  if not self:contains(obj) then return false end

  for i, o in ipairs(self.objects) do
    if o == obj then
      table.remove(self.objects, i)
      return true
    end
  end

  if self.divided then
    return (self.northeast:remove(obj) or
      self.northwest:remove(obj) or
      self.southeast:remove(obj) or
      self.southwest:remove(obj))
  end

  return false
end

function quadtree:teste()
  print("testando func qt")
end

function quadtree:remove_by_entity_id(entity_id)
  for i, obj in ipairs(self.objects) do
    if obj.entity == entity_id then
      table.remove(self.objects, i)
      return true
    end
  end

  if self.divided then
    return (self.northeast:remove_by_entity_id(entity_id) or
      self.northwest:remove_by_entity_id(entity_id) or
      self.southeast:remove_by_entity_id(entity_id) or
      self.southwest:remove_by_entity_id(entity_id))
  end

  return false
end

function quadtree:update(obj, new_bounds)
  if self:remove(obj) then
    obj.x = new_bounds.x
    obj.y = new_bounds.y
    obj.width = new_bounds.width
    obj.height = new_bounds.height
    self:insert(obj)
  end
end

function quadtree:query(range, found)
  found = found or {}

  if not self:intersects(range) then
    return found
  end

  for _, obj in ipairs(self.objects) do
    if self:checkintersection(obj, range) then
      table.insert(found, obj)
    end
  end

  if self.divided then
    self.northeast:query(range, found)
    self.northwest:query(range, found)
    self.southeast:query(range, found)
    self.southwest:query(range, found)
  end

  return found
end

-- verifica se um objeto está completamente dentro deste nó da quadtree
function quadtree:contains(obj)
  return obj.x >= self.bounds.x and
      obj.x + obj.width <= self.bounds.x + self.bounds.width and
      obj.y >= self.bounds.y and
      obj.y + obj.height <= self.bounds.y + self.bounds.height
end

-- verifica se uma área (range) intersecta com este nó da quadtree
function quadtree:intersects(range)
  return not (range.x > self.bounds.x + self.bounds.width or
    range.x + range.width < self.bounds.x or
    range.y > self.bounds.y + self.bounds.height or
    range.y + range.height < self.bounds.y)
end

-- verifica colisão aabb (axis-aligned bounding box) entre dois objetos
function quadtree:checkintersection(obj1, obj2)
  return obj1.x < obj2.x + obj2.width and
      obj1.x + obj1.width > obj2.x and
      obj1.y < obj2.y + obj2.height and
      obj1.y + obj1.height > obj2.y
end

return quadtree
