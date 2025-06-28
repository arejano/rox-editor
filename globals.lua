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
