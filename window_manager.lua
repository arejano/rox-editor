local utils = require "utils"

local WindowManager = {
  size = {
    width = 0,
    height = 0,
  },
  state = {
    focus = true
  }
}

WindowManager.__index = WindowManager

function WindowManager:init()
  self:update_size(nil)
end

function WindowManager:update_size()
  local w, h       = utils.GetWindowSize()
  self.size.width  = w
  self.size.height = h
end

---@param focus boolean
function WindowManager:update_focus(focus)
  self.state.focus = focus
  -- handler.update_focus()
end

return WindowManager
