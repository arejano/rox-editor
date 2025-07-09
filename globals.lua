_G.inspect = require "libs.inspect"
_G.love = love

function _G.GetWindowSize()
  return love.graphics.getWidth(), love.graphics.getHeight()
end

function _G.make_enum(t)
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


function _G.newUUID()
  local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
  return string.gsub(template, "[xy]", function(c)
    local v = (c == "x") and math.random(0, 15) or math.random(8, 11)
    return string.format("%x", v)
  end)
end


function _G.GetDisplayInfo()
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


function _G.deepCompare(a, b)
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
