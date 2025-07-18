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
  self:generateKeyMap(handler.keys)
end

function KeyboardManager:generateKeyMap(keys)
  for layer_name, hotkeys in pairs(keys) do
    for key, action in pairs(hotkeys) do
      self.layer_map[key] = layer_name
    end
  end

  print(utils.inspect(self.layer_map))
end

function KeyboardManager:process(key, pressed)
  self.pressed_keys[key] = pressed and pressed or nil

  local sorted = utils.sortTableByKeyLength(self.pressed_keys)
  local string_keys = utils.getKeys(sorted)
  local hotkey = table.concat(string_keys, "-")
  self.handler:handleKey(#hotkey > 0 and hotkey or nil, self.layer_map[hotkey])
end

return KeyboardManager
