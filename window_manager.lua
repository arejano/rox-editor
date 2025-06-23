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

function WindowManager:update_size(handler)
  local w, h       = GetWindowSize()
  self.size.width  = w
  self.size.height = h

  if handler == nil then return end
  
  handler.update_size()
end

---@param focus boolean
function WindowManager:update_focus(handler, focus)
  self.state.focus = focus
  handler.update_focus()
end

return WindowManager
