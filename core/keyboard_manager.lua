local utils = require("core.utils")

local KeyboardManager = {
  comands_by_state = {},
  pressed_keys = {}
}
KeyboardManager.__index = KeyboardManager

function KeyboardManager:new()
  local self = setmetatable({}, KeyboardManager)
  return self
end

function KeyboardManager:addKeys(state, keys)
  if state == nil then
    print("State deve ser informado para registrar keys")
    return
  end
  if keys == nil then
    print("Keys devem ser informadas")
    return
  end

  self.comands_by_state[state] = keys
end

function KeyboardManager:process(key, pressed)
  self.pressed_keys[key] = pressed and pressed or nil

  if pressed and self.pressed_keys["a"] or self.pressed_keys["r"] then
    EventManager:emit("update_fps", { data = "FPS", key = key })
  end
end

return KeyboardManager
