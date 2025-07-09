local RoxEvents = {
  events = {},
  watchers = {}
}
RoxEvents.__index = RoxEvents


function RoxEvents:new()
  self = {}
  return setmetatable(self, RoxEvents)
end

function RoxEvents:emit(event, id)
  print(event)
  for i, v in pairs(self.watchers[event]) do
    self.watchers[event][i](event)
  end
end

function RoxEvents:register(event_type, element, callback)
  self.watchers[event_type] = self.watchers[event_type] or {}
  self.watchers[event_type][element.ID] = callback or element.handleEvent
  print(self.watchers[event_type])
end

function RoxEvents:unregister(key, element)
  if self.watchers[key] then
    self.watchers[key][element.ID] = nil
  end
end

return RoxEvents
