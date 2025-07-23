local utils = require("core.utils")

local game_events = utils.make_enum({
  "Render",
  "KeyboardInput",
  "ProcessDirtyEntities"
})

return game_events
