local UIHandler = require "core.ui.handler"
local UIElement = require "core.ui.element"

---@class RoxEditor
---@field draw function
---@field markDirty function
---@field ui_handler UiHandler | nil
local RoxEditor = {
  ui_handler = nil,
}

RoxEditor.__index = RoxEditor


function RoxEditor:new()
  local obj = setmetatable({}, RoxEditor)
  obj.ui_handler = require 'editor.ui.editor_ui'
  return obj;
end

---@param mouseData  MouseClickData
function RoxEditor:mousePressed(mouseData)
  self.ui_handler:handleMouseClick(mouseData)
end

---@param mouseData  MouseClickData
function RoxEditor:mouseReleased(mouseData)
  self.ui_handler:handleMouseClick(mouseData)
end

function RoxEditor:mouseMoved(mousedata)
  self.ui_handler:mouseMoved(mousedata)
end

function RoxEditor:draw()
  self.ui_handler:render()
end

function RoxEditor:update(dt)
  self.ui_handler:update(dt)
end

function RoxEditor:resize()
  self.ui_handler:resize();
end

return RoxEditor
