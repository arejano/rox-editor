local utils = require("core.utils")
local c_types = utils.make_enum({
  "NULL",
  "Player",
  "Velocity",
  "Speed",
  "Running",
  "Transform",
  "Controllable",
  "Moving",
  "MovingBlocked",
  "Collidable",
  "Colliding",
  "Bullet",
  "Energy",
  "Dead",
  "Renderable",
  "Enemy"
})

return c_types
