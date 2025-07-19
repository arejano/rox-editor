local utils = require("core.utils")

local KeyboardManager = {
  handler = nil,
  pressed_keys = {},
  layer_map = {},
}
KeyboardManager.__index = KeyboardManager

function KeyboardManager:new()
  local self = setmetatable({}, KeyboardManager)
  return self
end

function KeyboardManager:registerHandler(handler)
  if handler == nil then
    print("Erro ao adicionar keys")
    return
  end

  self.handler = handler
  self:generateKeyMap(handler.layers)
end

function KeyboardManager:generateKeyMap(layers)
  for layer_name, hotkeys in pairs(layers) do
    for key, action in pairs(hotkeys) do
      self.layer_map[key] = layer_name
    end
  end
end

function KeyboardManager:process(key, pressed)
  self.pressed_keys[key] = pressed or nil

  if not next(self.pressed_keys) then
    self.handler:releaseKeyboard()
  end

  self.handler:handleKey(self.pressed_keys)
end

return KeyboardManager
