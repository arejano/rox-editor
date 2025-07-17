local UIHandler = require "core.ui.handler"
local UIElement = require "core.ui.element"

---@class Editor
---@field draw function
---@field ui_handler UIHandler | nil
local Editor = {
  global_keys = {},
  keys = {},
  ui_handler = nil,
}
Editor.__index = Editor

function Editor:new()
  local obj = setmetatable({}, Editor)
  obj.ui_handler = require 'editor.ui.editor_ui'
  return obj;
end

function Editor:mousePressed(x, y, button, istouch, presses)
  local mouseData = {
    x = x,
    y = y,
    button = button,
    istouch = istouch,
    presses = presses,
    pressed = true,
    release = false
  }
  self.ui_handler:handleMouseClick(mouseData)
end

function Editor:mouseReleased(x, y, button, istouch, presses)
  local mouseData = {
    x = x,
    y = y,
    button = button,
    istouch = istouch,
    presses = presses,
    pressed = false,
    release = true
  }
  self.ui_handler:handleMouseClick(mouseData)
end

function Editor:mouseMoved(mousedata)
  self.ui_handler:mouseMoved(mousedata)
end

function Editor:draw()
  self.ui_handler:render()
end

function Editor:update(dt)
  -- self.ui_handler:update(dt)
end

---@param w number
---@param h number
function Editor:resize(w, h)
  self.ui_handler:resize(w, h);
end

---@param focus boolean
function Editor:mouseFocus(focus)
  print("ChangeFocus", focus)
end

return Editor
