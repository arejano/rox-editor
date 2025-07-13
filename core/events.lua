-- core/global_state.lua
local GlobalState = {
  _data = {},
  _subscribers = setmetatable({}, { __mode = "k" }) -- Weak tables para GC
}
GlobalState.__index = GlobalState

function GlobalState:new()
  return setmetatable({}, GlobalState)
end

function GlobalState:watch(key, element, callback)
  self._subscribers[key] = self._subscribers[key] or {}
  self._subscribers[key][element] = callback or element.onDataUpdate
end

function GlobalState:unwatch(key, element)
  if self._subscribers[key] then
    self._subscribers[key][element] = nil
  end
end

function GlobalState:set(key, value)
  -- Deep compare para evitar notificações desnecessárias
  -- if not deepCompare(self._data[key], value) then
  self._data[key] = value
  if self._subscribers[key] then
    for element, callback in pairs(self._subscribers[key]) do
      callback(element, value)
    end
  end
  -- end
end

function GlobalState:get(key)
  return self._data[key]
end

return GlobalState
