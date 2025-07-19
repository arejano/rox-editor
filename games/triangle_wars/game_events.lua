local utils = require("core.utils")

local game_events = utils.make_enum({
  "Render",
  "KeyboardInput",
  "StopPlayerMove"
})

return game_events
