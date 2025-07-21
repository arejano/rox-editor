local utils = {}

utils.inspect = require "libs.inspect"

function utils.GetWindowSize()
  return love.graphics.getWidth(), love.graphics.getHeight()
end

function utils.make_enum(t)
  local enum = {}


  for i, v in ipairs(t) do
    enum[v] = i
  end

  return setmetatable(enum, {
    __index = function(_, key)
      error("Chave" .. tostring(key) .. "nao existe no enum")
    end,
    __newindex = function(_, _, _)
      error("Nao eh possivel modificar o enum");
    end
  })
end

function utils.newUUID()
  local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
  return string.gsub(template, "[xy]", function(c)
    local v = (c == "x") and math.random(0, 15) or math.random(8, 11)
    return string.format("%x", v)
  end)
end

function utils.GetDisplayInfo()
  -- Segue a numeracao do SO
  -- 1 Primario
  -- 2 Secundario
  local displays = love.window.getDisplayCount()
  local targetDisplay = 2

  if targetDisplay > displays then
    targetDisplay = 1
  end

  local w, h = love.window.getDesktopDimensions(targetDisplay)
  return w, h, targetDisplay
end

function utils.deepCompare(a, b)
  -- Comparação para tipos diferentes
  if type(a) ~= type(b) then
    return false
  end

  -- Comparação para valores não-tabela
  if type(a) ~= "table" then
    return a == b
  end

  -- Comparação de metatabelas
  local metaA = getmetatable(a)
  local metaB = getmetatable(b)
  if not deepCompare(metaA, metaB) then
    return false
  end

  -- Contagem de chaves na tabela A
  local keyCount = 0
  for k, v in pairs(a) do
    keyCount = keyCount + 1
    if not deepCompare(v, b[k]) then
      return false
    end
  end

  -- Verifica se todas as chaves de B existem em A
  for k in pairs(b) do
    keyCount = keyCount - 1
    if keyCount < 0 then
      return false
    end
  end

  return true
end

function utils.debug_position()
  local w, h, target = utils.GetDisplayInfo()
  love.window.setMode(
    w,
    h,
    { display = target, resizable = true }
  )
end

function utils.isInvalidResize(w, h, minWidth, minHeight)
  return w < minWidth or h < minHeight
end

function utils.deepCopy(orig, copies)
  copies = copies or {}

  if type(orig) ~= 'table' then
    return orig
  elseif copies[orig] then
    return copies[orig] -- evita loops infinitos em tabelas recursivas
  end

  local copy = {}
  copies[orig] = copy

  for k, v in pairs(orig) do
    copy[utils.deepCopy(k, copies)] = utils.deepCopy(v, copies)
  end

  -- copia o metatable, se houver
  setmetatable(copy, utils.deepCopy(getmetatable(orig), copies))

  return copy
end

function utils.sortTableByKeyLength(input)
  local result = {}
  for k, v in pairs(input) do
    table.insert(result, { key = k, value = v })
  end

  table.sort(result, function(a, b)
    return #a.key > #b.key
  end)

  return result
end

function utils.getKeys(input)
  local result = {}
  for k, v in pairs(input) do
    table.insert(result, v.key)
  end
  return result
end

function utils.removeFromTable(t, value_to_remove)
  for i = 1, #t do
    if t[i] == value_to_remove then
      t[i] = t[#t] -- move o último para a posição atual
      t[#t] = nil  -- remove o último
      -- break        -- se quiser remover só uma ocorrência
    end
  end
end

function utils.firstKey(t)
  for k, _ in pairs(t) do
    return k or nil
  end
end

function utils.componentLabel(type, c_types)
  local finished = false

  for k, v in pairs(c_types) do
    if v == type then
      finished = true
      return k
    end

    if finished then
      break
    end
  end
end

function utils.getSizeOfSet(set)
  local count = 0
  for _ in pairs(set) do
    count = count + 1
  end
  return count
end

return utils
