local ecs = require 'core.ecs'.new()


local function test_add_entity()
  local entity = {
    { type = 1,  data = { id = 1, name = "Test Entity", components = {} } },
    { type = 2,  data = { id = 1, name = "Test Entity", components = {} } },
    { type = 3,  data = { id = 1, name = "Test Entity", components = {} } },
    { type = 1,  data = { id = 1, name = "Test Entity", components = {} } },
    { type = 5,  data = { id = 1, name = "Test Entity", components = {} } },
    { type = 6,  data = { id = 1, name = "Test Entity", components = {} } },
    { type = 7,  data = { id = 1, name = "Test Entity", components = {} } },
    { type = 8,  data = { id = 1, name = "Test Entity", components = {} } },
    { type = 9,  data = { id = 1, name = "Test Entity", components = {} } },
    { type = 10, data = { id = 1, name = "Test Entity", components = {} } },
  }

  local entity_2 = {
    { type = 1,  data = { id = 1, name = "Test Entity", components = {} } },
    { type = 2,  data = { id = 1, name = "Test Entity", components = {} } },
    { type = 3,  data = { id = 1, name = "Test Entity", components = {} } },
    { type = 4,  data = { id = 1, name = "Test Entity", components = {} } },
    { type = 5,  data = { id = 1, name = "Test Entity", components = {} } },
    { type = 6,  data = { id = 1, name = "Test Entity", components = {} } },
    { type = 7,  data = { id = 1, name = "Test Entity", components = {} } },
    { type = 8,  data = { id = 1, name = "Test Entity", components = {} } },
    { type = 9,  data = { id = 1, name = "Test Entity", components = {} } },
    { type = 10, data = { id = 1, name = "Test Entity", components = {} } },
  }
  local max_entity = 10000
  local inserted = 0
  for i = 1, max_entity do
    ecs:addEntity(entity)
    inserted = inserted + 1
  end

  for i = 1, max_entity / 2 do
    ecs:addEntity(entity_2)
    inserted = inserted + 1
  end

  assert(ecs.counters.entity == inserted + 1, string.format("Expected entity counter to be %10d", inserted))
  -- assert(#ecs.entities_by_component[1] == max_entity,
  -- string.format("Expected component counter to be %X", ecs.counters.component))

  print("----------------------------------------------------")
  print("test_add_entity::passed")
  print(string.format("Total de entidades inseridas: %10d", inserted))
end
elapsed_time(test_add_entity)



local function test_query()
  local total_entidades = 0

  local queryes = {
    ecs.query({ 1 }),
    ecs.query({ 2 }),
    ecs.query({ 3 }),
    ecs.query({ 4 }),
    ecs.query({ 1, 2, 3, 4 }),
    ecs.query({ 1, 2, 3, 5, 6, 7 }),
  }

  for i, k in ipairs(queryes) do
    total_entidades = total_entidades + #k
  end

  print("----------------------------------------------------")
  print("Numero de queries: 4")
  print(string.format("Total de entidades retornadas: %10d", (total_entidades)))
  print("test_query::passed")
end
elapsed_time(test_query)


local function test_add_system()
  local system = require 'systems.log_system'
  local new_id = ecs:add_system(system)
  assert(ecs.systems[new_id] ~= nil, "Expected system ~= nil")
  print("----------------------------------------------------")
  print("test_add_system::passed")
end
elapsed_time(test_add_system)
