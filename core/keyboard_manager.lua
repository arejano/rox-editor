local utils = require("core.utils")

local KeyboardManager = {
  global_layer = {},
  handler_layer = {},
  pressed_keys = {},
  comands_by_state = {},
}
KeyboardManager.__index = KeyboardManager

function KeyboardManager:new()
  local self = setmetatable({}, KeyboardManager)
  return self
end

function KeyboardManager:addKeys(handler, keys)
  if handler == nil or keys == nil then
    print("Erro ao adicionar keys")
    return
  end

  self.handler_layer[handler] = keys
end

function KeyboardManager:addGlobalKeys(handler, keys)
  if handler == nil or keys == nil then
    print("Erro ao adicionar keys globais")
    return
  end

  self.global_layer[handler] = keys
end

function KeyboardManager:process(key, pressed)
  self.pressed_keys[key] = pressed and pressed or nil

  local global_success = self:processGlobalLayer()

  if global_success then return end

  local handler_success = self:processHandlerLayer()
end

function KeyboardManager:processGlobalLayer()
  local processed = false
  for layer, keys in pairs(self.global_layer) do
    for key, command in pairs(keys) do
      if self.pressed_keys[key] then
        EventManager:emit(command, command)
        processed = true
      end
    end
  end

  return processed
end

function KeyboardManager:processHandlerLayer()
  -- local processed = false
  -- for layer, keys in pairs(self.global_layer) do
  --   for key, command in pairs(keys) do
  --     if self.pressed_keys[key] then
  --       EventManager:emit(command)
  --       processed = true
  --     end
  --   end
  -- end

  -- return processed
end

return KeyboardManager
