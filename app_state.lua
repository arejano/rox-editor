local game_state  = require("core.game_state")
local game_events = require("games.triangle_wars.game_events")
local utils       = require("core.utils")

-- ACHAR UMA FORMA DE NAO REPETIR AS KEYS E COMMANDS

---@class AppState
---@field Editor Editor | nil
---@field Game Ecs | nil
---@field Debugger nil
local AppState    = {
  global_keys = {
    ["f1"] = "main/focus/editor",
    ["f2"] = "main/focus/game",
    ["f3"] = "main/focus/debugger",
    ["p"] = "main/pause"
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

function AppState:getCommandsByKeys()
  local commands = {}
  for i, v in pairs(self.global_keys) do
    table.insert(commands, v)
  end
  return commands
end

function AppState:consumeEvent(command)
  self:defineFocus(command)

  if command == "main/pause" then
    self.Game.state = game_state.Paused
    self.Game.ecs:add_event({
      type = game_events.Render,
      data = nil
    })
    return
  end
end

function AppState:defineFocus(command)
  local focus_commands = {
    ["main/focus/editor"] = self.Editor,
    ["main/focus/game"] = self.Game,
    ["main/focus/debugger"] = self.Debugger,
  }

  self.handler_focus = focus_commands[command] and focus_commands[command] or nil
end

return AppState
