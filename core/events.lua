-- core/global_state.lua
local EventManager = {
  _subscribers = setmetatable({}, { __mode = "k" }) -- Weak tables para GC
}
EventManager.__index = EventManager

function EventManager:new()
  return setmetatable({}, EventManager)
end

function EventManager:watch(key, element, callback)
  self._subscribers[key] = self._subscribers[key] or {}
  self._subscribers[key][element] = callback or element.consumeEvent
end

function EventManager:manyWatch(watchers, element)
  for i, v in ipairs(watchers) do
    self:watch(v, element)
  end
end

function EventManager:unwatch(key, element)
  if self._subscribers[key] then
    self._subscribers[key][element] = nil
  end
end

function EventManager:emit(key, event)
  if self._subscribers[key] then
    for element, callback in pairs(self._subscribers[key]) do
      callback(element, event)
    end
  end
end

return EventManager
