local utils = require("core.utils")

---@class Event
---@field eventType  EventType

---@class Position
---@field x number
---@field y number

---@class Size
---@field width number
---@field height number



---@class SpatialEntity
---@field id string
---@field position Position
---@field size Size


---@enum EventType
local event_types = utils.make_enum({
  "Command",
  "Game",
  "Editor",
  "Debugger",
  "UIUpdate"
})

local editor_commands = {
  Save = "editor/save",
  Load = "editor/load",
  Close = "editor/slose",
  Cut = "editor/cut",
  Copy = "editor/copy",
  Undo = "editor/undo",
  Redo = "editor/redo",
}

local game_commands = {
  Pause = '',
  Start = '',
  Save = '',
  Walking = '',
}

return {
  editor = editor_commands
}
