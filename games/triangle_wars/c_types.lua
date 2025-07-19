local utils = require("core.utils")
local c_types = utils.make_enum({
  "Player",
  "Velocity",
  "Running",
  "Transform"
})

return c_types
