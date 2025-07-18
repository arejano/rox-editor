local game_state  = require("core.game_state")
local game_events = require("games.triangle_wars.game_events")
local utils       = require("core.utils")

-- ACHAR UMA FORMA DE NAO REPETIR AS KEYS E COMMANDS

---@class AppState
---@field Editor Editor | nil
---@field Game TriangleWarsGame | nil
---@field Debugger nil
local AppState    = {
  keys = {
    global = {
      ["f1"] = "main/focus/editor",
      ["f2"] = "main/focus/game",
      ["f3"] = "main/focus/debugger",
    },
    editor = {
      ["lctrl-s"] = "save",
      ["lctrl-n"] = "new",
      ["lctrl-o"] = "open",
    },
    game = {
      ["p"] = "main/pause",
      ["a"] = "game/left",
      ["w"] = "game/up",
      ["s"] = "game/down",
      ["d"] = "game/right",
      ["lshift-a"] = "Running/Left",
      ["lshift-a-w"] = "Running/Left/Up",
      ["lshift-a-s"] = "Running/Left/Down",
      ["lshift-a-d"] = "Running/Left/Right",
      ["lshift-w"] = "Running/up",
      ["lshift-s"] = "Running/Down",
      ["lshift-d"] = "Running/Right",
    }
  },
  events_by_layer = {
    game = game_events.KeyboardInput,
    editor = nil,
    global = nil,
    debugger = nil
  },
  Editor = nil,
  Game = nil,
  Debugger = nil,
  handler_focus = nil,
}
AppState.__index  = AppState

function AppState:new()
  local self = { handler_focus = nil, }
  return setmetatable(self, AppState);
end

function AppState:handleKey(event_data, key_layer)
  if event_data == nil then
    return
  end

  if key_layer == "global" then
    self:handleGlobalKey(event_data)
    return
  end

  self:handleLayerKey(key_layer, event_data)
end

function AppState:handleLayerKey(key_layer, event_data)
  if self.keys[key_layer] then
    local action = self.keys[key_layer][event_data]


    local new_event = {
      type = self.events_by_layer[key_layer],
      data = action
    }

    if key_layer == "editor" then
      print("Editor:Keyboard")
      return
    end

    if key_layer == "game" then
      self.Game:newEvent(new_event)
      return
    end
  end
end

function AppState:handleGlobalKey(event_data)
  print("Hotkey:Global: " .. event_data)
end

function AppState:newGameEvent(event, data)
  self.Game.ecs:add_event({
    type = event,
    data = data or nil
  })
end

return AppState
