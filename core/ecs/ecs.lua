local game_state = require("core.game_state")
local game_events = require("games.triangle_wars.game_events")
local utils = require("core.utils")
local c_types = require("games.triangle_wars.c_types")

---@class Ecs
---@field new function
---@field update function
---@field add_resource function
---@field get_resource function
---@field add_event function
---@field state GameState
local Ecs = {
  state = game_state.Starting,
  -- Entity-Component
  entities = {},
  dirty_entities = {},
  entities_by_component = {},
  components = {},
  -- systems
  systems = {},
  systems_status = {},
  systems_by_event = {},
  systems_by_component = {},
  -- Pool Event
  pool_event = {},
  pool = { first = 0, last = 1 },
  -- Resources | Render, Physics | Desvinculados de Eventos
  resources = {},
  query_cache = {}, -- Inicializa cache
  -- Chaves em string para cada componente
  components_keys = {},
  -- Chaves em int para cada string/id de componente
  components_ids = {},
  components_counter = {
  }
}
Ecs.__index = Ecs

function Ecs:new()
  local ecs = {}
  setmetatable(ecs, Ecs)
  return ecs
end

---@return number|table|nil

-- NOVA FUNÇÃO: Registra queries para cache
function Ecs:register_query(component_types, cache_key)
  cache_key = cache_key or table.concat(component_types, ",")
  self.query_cache[cache_key] = {
    types = component_types,
    result = {},
    dirty = true
  }
  return cache_key
end

function Ecs:query_first(c_types, system_info, cache_key)
  local entities = self:query(c_types)
  if entities ~= nil then
    return utils.firstKey(entities)
  end
  return nil
end

function Ecs:query(components, ignores)
  local entity_set_result = {}

  -- Prepare
  components = self:get_components_ids(components)


  --Validator
  if components == nil then
    print("component_types == NIL")
    return {}
  end

  -- Find
  for c_id, v in pairs(components) do
    for entity_id, value in pairs(self.entities_by_component[c_id]) do
      entity_set_result[entity_id] = true
    end
  end

  -- Remover ignorados
  if ignores then
    local ign = self:get_components_ids(ignores)
    for c_id, v in pairs(ign) do
      if self.entities_by_component[c_id] then
        for entity_id, value in pairs(self.entities_by_component[c_id]) do
          entity_set_result[entity_id] = nil
        end
      end
    end
  end


  -- local entities = {}
  -- Isso eh maior performatico que table.insert()
  -- local i = 1
  -- for k, v in pairs(entities_set) do
  --   entities[i] = k
  --   i = i + 1
  -- end

  return entity_set_result
end

---comment
---@return string
function Ecs:add_entity(components)
  -- assert(is_component(components), "Some component is invalid")
  local entity_id = utils.newUUID();

  for _, component in ipairs(components) do
    self:register_component(entity_id, component)
  end

  self.dirty_entities[entity_id] = true
  return entity_id
end

-- NOVA FUNÇÃO: Marca queries como dirty quando componentes são alterados
function Ecs:register_component(entity_id, component)
  -- assert(is_valid_component(component), "Invalid Component")

  local component_ID = self:new_component_id(component.type)

  if not self.entities_by_component[component_ID] then
    self.entities_by_component[component_ID] = {}
  end
  self.entities_by_component[component_ID][entity_id] = true

  local componentName = utils.componentLabel(component.type, c_types)

  -- Definir os dados do componente vinculados a entidade
  -- local key = entity_id .. component_ID
  -- self.components[key] = component.data
  if not self.components[entity_id] then
    self.components[entity_id] = {}
  end
  self.components[entity_id][component_ID] = component.data


  -- Incluir na entidade o componente registrado
  if self.entities[entity_id] == nil then
    self.entities[entity_id] = {}
  end

  self.entities[entity_id][component_ID] = true

  -- Marca queries como dirty
  for cache_key, cached_query in pairs(self.query_cache) do
    for _, query_type in ipairs(cached_query.types) do
      if query_type == component.type then
        cached_query.dirty = true
        break
      end
    end
  end
  self.dirty_entities[entity_id] = true
  self:update_component_counter(component.type)
end

function Ecs:new_component_id(type)
  if not self.components_keys[type] then
    local new_id = utils.newUUID()
    self.components_keys[type] = new_id
    self.components_ids[new_id] = type
  end
  local component_ID = self.components_keys[type]
  return component_ID
end

function Ecs:remove_component(entity_id, type)
  if not entity_id then return end
  local key                       = self:new_component_id(type)
  self.entities[entity_id][key]   = nil
  self.components[entity_id][key] = nil
  if self.entities_by_component[key] then
    self.entities_by_component[key][entity_id] = nil
  end

  self.dirty_entities[entity_id] = true
  self:update_component_counter(type)
end

function Ecs:update_component_counter(c_type)
  local name = utils.componentLabel(c_type, c_types)
  local id = self.components_keys[c_type]

  if not self.components_counter[name] then
    self.components_counter[name] = 0
  end

  if self.entities_by_component[id] then
    self.components_counter[name] = utils.getSizeOfSet(self.entities_by_component[id])
  end

  self:update_system_watchs_status(id)
end

function Ecs:update_system_watchs_status(id)
  local systems = self.systems_by_component[id]
  if not systems then return end

  for k, v in pairs(systems) do
    local sys = self.systems[k]
    local active = false

    if sys then
      for _, c_type in ipairs(sys.watch) do
        local name = utils.componentLabel(c_type, c_types)
        if self.components_counter[name] and self.components_counter[name] > 0 then
          active = true
          self.systems_status[sys.id] = true
        else
          self.systems_status[sys.id] = nil
        end
      end
    end

    sys.running = active
  end
end

-- NOVA FUNÇÃO: Limpa cache para uma query específica
function Ecs:invalidate_query_cache(cache_key)
  if self.query_cache[cache_key] then
    self.query_cache[cache_key].dirty = true
  end
end

function Ecs:add_system(system)
  -- assert(is_valid_system(system), "system need a PROCESS method")
  -- local new_id = self:newId("system")
  system.id = utils.newUUID()
  self.systems[system.id] = system

  if system.track then
    self.systems_status[system.id] = true
  end



  if system.start then
    system:start(self)
  end

  -- Registrando sistemas que escutam eventos
  if system.events then
    for _, event in pairs(system.events) do
      if self.systems_by_event[event] == nil then
        self.systems_by_event[event] = {}
      end
      table.insert(self.systems_by_event[event], system.id)
    end
  end

  -- Registrando sistemas que executam quando componente existe
  if system.watch then
    for _, c in ipairs(system.watch) do
      if not self.components_keys[c] then
        self.components_keys[c] = utils.newUUID()
      end
      if not self.systems_by_component[self.components_keys[c]] then
        self.systems_by_component[self.components_keys[c]] = {}
      end
      self.systems_by_component[self.components_keys[c]][system.id] = true
    end
  end

  return system.id
end

function Ecs:add_resource(type, resource)
  if self.resources[type] == nil then
    self.resources[type] = {}
  end
  table.insert(self.resources[type], resource)
end

function Ecs:get_resource(resource_name)
  return self.resources[resource_name][1] or {}
end

function Ecs:add_event(event)
  local last = self.pool.last + 1
  self.pool.last = last
  self.pool[last .. "_"] = event
end

function Ecs:pop_event()
  local first = self.pool.first
  if first > self.pool.last then return nil end
  local event = self.pool[first .. "_"]
  self.pool[first .. "_"] = nil
  self.pool.first = first + 1
  return event
end

---@param dt number
---@param pass boolean
function Ecs:update(dt, pass)
  if dt then
    self.delta_time = dt
  end

  -- Sistemas por evento
  while true do
    local event = self:pop_event()
    if not event then break end

    local to_run = self.systems_by_event[event.type]
    if to_run == nil then return end

    for _, s in pairs(to_run) do
      local system = self.systems[s]
      if system.process and system.running then
        system:process(self, self.delta_time, event, pass)
      end
    end
  end

  -- Sistemas que sempre executam quando existe componente para ele
  for key, _ in pairs(self.systems_status) do
    self.systems[key]:process(self, self.delta_time)
  end


  if utils.getSizeOfSet(self.dirty_entities) > 0 then
    self:add_event({
      type = game_events.ProcessDirtyEntities,
      data = nil,
    })
  end
end

---@param entity integer
---@param c_type integer
function Ecs:get_component(entity, c_type)
  if entity == nil then return nil end
  return {
    data = self.components[entity][self.components_keys[c_type]]
  }
end

function Ecs:set_component(entity, c_type, data)
  if entity == nil or c_type == nil or data == data == nil then
    return
  end

  self.components[entity][self.components_keys[c_type]] = data
  self.dirty_entities[entity] = true
end

-- function Ecs:working_remove_entity(entity_id)
--   local component_types = self.entities[entity_id]
--   if not component_types then return end

--   for _, c_type in ipairs(component_types) do
--     -- Remover da lista de entidades por componente
--     local entities = self.entities_by_component[c_type]
--     if entities then
--       for i = #entities, 1, -1 do
--         if entities[i] == entity_id then
--           table.remove(entities, i)
--           break
--         end
--       end
--     end

--     -- Remover do dicionário de componentes
--     self.components[entity_id .. c_type] = nil

--     -- Marcar queries como dirty
--     for cache_key, cached_query in pairs(self.query_cache) do
--       for _, query_type in ipairs(cached_query.types) do
--         if query_type == c_type then
--           cached_query.dirty = true
--           break
--         end
--       end
--     end
--   end

--   -- Finalmente, remove a referência da entidade
--   self.entities[entity_id] = nil
-- end

-- function Ecs:remove_entity(entity_id)
--   if not self.entities[entity_id] then return false end

--   -- Otimização: tabela temporária para tipos de componentes
--   local component_types = {}
--   for _, ct in ipairs(self.entities[entity_id]) do
--     component_types[ct] = true
--   end

--   -- Remove componentes
--   for ct, _ in pairs(component_types) do
--     self.components[entity_id .. ct] = nil

--     -- Remove de entities_by_component
--     local ebct = self.entities_by_component[ct]
--     if ebct then
--       for i = #ebct, 1, -1 do
--         if ebct[i] == entity_id then
--           table.remove(ebct, i)
--         end
--       end
--     end

--     -- Invalida cache
--     for cache_key, cached_query in pairs(self.query_cache) do
--       if component_types[cached_query.types[1]] then -- Verificação otimizada
--         cached_query.dirty = true
--       end
--     end
--   end

--   self.entities[entity_id] = nil
--   -- self:add_event({ type = game_events.EntityRemoved, data = entity_id })
--   return true
-- end

-- Utils
function Ecs:get_components_ids(components)
  local result = {}

  if not components then return result end

  for k, v in pairs(components) do
    local c_key = self:new_component_id(v)
    -- table.insert(tt, c_key)
    result[c_key] = true
    -- print(utils.inspect(tt))
  end
  return result
end

function Ecs:getActiveComponents()
  local components_ids = {}
  for k, v in pairs(self.entities_by_component) do
    table.insert(components_ids, {
      label = utils.componentLabel(self.components_ids[k], c_types)
    })
  end
  return components_ids
end

function Ecs:count_sys_runners()
  local counter = 0
  for k, v in pairs(self.systems) do
    if v.running then counter = counter + 1 end
  end
  return counter
end

function Ecs:getEntityInfo(id)
  local entity = self.entities[id]

  local components = {}

  for k, _ in pairs(entity) do
    local c_type = self.components_ids[k]
    table.insert(components, utils.componentLabel(c_type, c_types))
  end

  local result = {
    componentes = components
  }

  return result
end

function Ecs:entity_has_component(entity_id, c_type)
  return self.entities[entity_id][self.components_keys[c_type]] ~= nil
end

return Ecs
