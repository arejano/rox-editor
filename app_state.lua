local game_state  = require("core.game_state")
local game_events = require("games.triangle_wars.game_events")
local utils       = require("core.utils")

-- ACHAR UMA FORMA DE NAO REPETIR AS KEYS E COMMANDS

---@class AppState
---@field Editor Editor | nil
---@field Game TriangleWarsGame | nil
---@field Debugger nil
local AppState    = {
  layers = {
    global = {
      ["f1"] = "main/focus/editor",
      ["f2"] = "main/focus/game",
      ["f3"] = "main/focus/debugger",
      ["escape"] = "main/focus/debugger",
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
      ["lshift"] = "game/run",
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

function AppState:handleKey(pressed_keys, key_layer)
  -- Global
  local global = false
  for k, v in pairs(pressed_keys) do
    if self.layers.global[k] then
      self:handleGlobalKey(pressed_keys)
      global = true
      break
    end
  end
  if global then return end

  -- Editor
  local editor = false
  for k, v in pairs(pressed_keys) do
    if self.layers.editor[k] then
      editor = true
      -- self:handleGlobalKey(pressed_keys)
      break
    end
  end
  if editor then return end

  -- Game
  for k, v in pairs(pressed_keys) do
    if self.layers.game[k] then
      self.Game:newEvent({
        type = game_events.KeyboardInput,
        data =
            pressed_keys

      })
      break
    end
  end
end

function AppState:handleGlobalKey(event_data)
  print("Hotkey:Global: " .. utils.inspect(event_data))
end

function AppState:releaseKeyboard()
  self.Game:newEvent({
    type = game_events.KeyboardInput,
    data = nil
  })
end

function AppState:newGameEvent(event, data)
  self.Game.ecs:add_event({
    type = event,
    data = data or nil
  })
end

return AppState
