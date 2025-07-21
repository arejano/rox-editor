local game_state = require("core.game_state")
local game_events = require("games.triangle_wars.game_events")
local utils = require("core.utils")

---@class Ecs
---@field new function
---@field update function
---@field add_resource function
---@field get_resource function
---@field add_event function
---@field state GameState
local Ecs = {
  state = game_state.Starting,
  --id_counters
  counters = {
    entity = 1,
    component = 1,
    system = 1,
    last_sys_run = 0,
  },
  -- Entity-Component
  entities = {},
  entities_by_component = {},
  components = {},
  -- systems
  systems = {},
  systems_status = {},
  systems_by_event = {},
  -- Pool Event
  pool_event = {},
  -- Resources | Render, Physics | Desvinculados de Eventos
  resources = {},
  query_cache = {}, -- Inicializa cache
  components_keys = {},
}
Ecs.__index = Ecs

function Ecs:new()
  local ecs = {
    counters = {
      entity = 1,
      component = 1,
      system = 1,
      last_sys_run = 0,
    },
  }
  setmetatable(ecs, Ecs)
  return ecs
end

function Ecs:newId(key)
  self.counters[key] = self.counters[key] + 1
  return self.counters[key]
end

---@return number|table|nil
function Ecs:query_first(c_types, system_info, cache_key)
  local entity = self:query(c_types, system_info, cache_key)
  if entity ~= nil and #entity > 0 then
    return entity[1]
  end
  return nil
end

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

function Ecs:query(component_types, system_info, cache_key)
  local tt = {}
  for k, v in pairs(component_types) do
    table.insert(tt, self.components_keys[v])
  end

  component_types = tt

  if cache_key and self.query_cache[cache_key] and not self.query_cache[cache_key].dirty then
    return self.query_cache[cache_key].result
  end

  if component_types == nil or #component_types == 0 then
    print("component_types == NIL")
    return {}
  end

  -- sort
  local min_key = component_types[1]
  if min_key == nil then return {} end

  for _, c_type in ipairs(component_types) do
    if self.entities_by_component[c_type] == nil then
      return {}
    end

    if #self.entities_by_component[c_type] < #self.entities_by_component[min_key] then
      min_key = c_type
    end
  end

  local entity_set = {}
  for _, entity in ipairs(self.entities_by_component[min_key]) do
    entity_set[entity] = true
  end
  -- end sort

  for _, key in ipairs(component_types) do
    if key ~= min_key then
      local new_set = {}
      for _, entity in ipairs(self.entities_by_component[key]) do
        if entity_set[entity] then
          new_set[entity] = true
        end
      end
      entity_set = new_set
    end
  end

  local result = {}
  for key, value in pairs(entity_set) do
    table.insert(result, key)
  end

  -- Atualiza cache se necessário
  if cache_key and self.query_cache[cache_key] then
    self.query_cache[cache_key].result = result
    self.query_cache[cache_key].dirty = false
  end

  return result
end

---comment
---@param components Component
---@return string
function Ecs:add_entity(components)
  -- assert(is_component(components), "Some component is invalid")
  local entity_id = utils.newUUID();

  for _, component in ipairs(components) do
    self:register_component(entity_id, component)
  end
  return entity_id
end

-- NOVA FUNÇÃO: Marca queries como dirty quando componentes são alterados
function Ecs:register_component(entity_id, component)
  -- assert(is_valid_component(component), "Invalid Component")
  if not self.components_keys[component.type] then
    self.components_keys[component.type] = utils.newUUID()
  end

  local component_ID = self.components_keys[component.type]

  if self.entities_by_component[component_ID] == nil then
    self.entities_by_component[component_ID] = {}
  end
  table.insert(self.entities_by_component[component_ID], entity_id)

  -- Definir os dados do componente vinculados a entidade
  local key = entity_id .. component_ID
  self.components[key] = component.data

  if self.entities[entity_id] == nil then
    self.entities[entity_id] = {}
  end


  -- Incluir na entidade o componente registrado
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
end

function Ecs:remove_component(entity_id, component)
  local component_key = self.components_keys[component.type]
  self.entities[entity_id][component_key] = nil
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


  self.systems_status[system.id] = true

  if system.start then
    system:start(self)
  end

  if system.events then
    for _, event in pairs(system.events) do
      if self.systems_by_event[event] == nil then
        self.systems_by_event[event] = {}
      end
      table.insert(self.systems_by_event[event], system.id)
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
  return self.resources[resource_name] or {}
end

---@param event = NewEvent
function Ecs:add_event(event)
  table.insert(self.pool_event, event)
end

---@param dt number
---@param pass boolean
function Ecs:update(dt, pass)
  if dt then
    self.delta_time = dt
  end

  while #self.pool_event > 0 do
    local event = table.remove(self.pool_event, 1)

    local to_run = self.systems_by_event[event.type]

    if to_run == nil then return end

    self.counters.last_sys_run = #to_run
    for _, s in pairs(to_run) do
      local system = self.systems[s]

      -- if self.systems_status[s] == true then
      if system.process and system.running then
        system:process(self, self.delta_time, event, pass)
      end
      -- end
    end
  end
end

---@param entity integer
---@param c_type integer
function Ecs:get_component(entity, c_type)
  if entity == nil then return nil end
  local component_key = self.components_keys[c_type]
  return {
    key = entity .. component_key,
    data = self.components[entity .. component_key]
  }
end

function Ecs:set_component(entity, c_type, data)
  if entity == nil or c_type == nil or data == data == nil then
    return
  end

  self.components[entity .. c_type] = data
end

function Ecs:working_remove_entity(entity_id)
  local component_types = self.entities[entity_id]
  if not component_types then return end

  for _, c_type in ipairs(component_types) do
    -- Remover da lista de entidades por componente
    local entities = self.entities_by_component[c_type]
    if entities then
      for i = #entities, 1, -1 do
        if entities[i] == entity_id then
          table.remove(entities, i)
          break
        end
      end
    end

    -- Remover do dicionário de componentes
    self.components[entity_id .. c_type] = nil

    -- Marcar queries como dirty
    for cache_key, cached_query in pairs(self.query_cache) do
      for _, query_type in ipairs(cached_query.types) do
        if query_type == c_type then
          cached_query.dirty = true
          break
        end
      end
    end
  end

  -- Finalmente, remove a referência da entidade
  self.entities[entity_id] = nil
end

function Ecs:remove_entity(entity_id)
  if not self.entities[entity_id] then return false end

  -- Otimização: tabela temporária para tipos de componentes
  local component_types = {}
  for _, ct in ipairs(self.entities[entity_id]) do
    component_types[ct] = true
  end

  -- Remove componentes
  for ct, _ in pairs(component_types) do
    self.components[entity_id .. ct] = nil

    -- Remove de entities_by_component
    local ebct = self.entities_by_component[ct]
    if ebct then
      for i = #ebct, 1, -1 do
        if ebct[i] == entity_id then
          table.remove(ebct, i)
        end
      end
    end

    -- Invalida cache
    for cache_key, cached_query in pairs(self.query_cache) do
      if component_types[cached_query.types[1]] then -- Verificação otimizada
        cached_query.dirty = true
      end
    end
  end

  self.entities[entity_id] = nil
  -- self:add_event({ type = game_events.EntityRemoved, data = entity_id })
  return true
end

return Ecs
