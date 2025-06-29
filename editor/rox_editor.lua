local UiHandler = require "editor.ui_handler"
local UiElement = require "editor.ui_element"

local ResizeMode = require "editor.enum_resize_mode"

---@class RoxEditor
---@field draw function
---@field markDirty function
---@field ui_handler UiHandler | nil
local RoxEditor = {
  ui_handler = nil,
}

RoxEditor.__index = RoxEditor

function RoxEditor:mousePressed()
  self.ui_handler:handleMouseClick()
end

function RoxEditor:mouseMoved()
  local x, y = love.mouse.getPosition()

  local focusedElement = self.ui_handler:handleMouseMove(x, y)

  -- Você pode adicionar lógica adicional aqui
  if focusedElement then
    local cursor_type = focusedElement:getCursorType();
    if cursor_type ~= nil then
      love.mouse.setCursor(love.mouse.getSystemCursor(cursor_type))
    else
      love.mouse.setCursor()
    end
  end
  return focusedElement
end

function RoxEditor:new()
  local obj = setmetatable({}, RoxEditor)

  obj.ui_handler = UiHandler:new()

  local w, h = GetWindowSize();
  local base_panel_width = 200

  -- LeftPanel
  obj.ui_handler:addElement(require 'editor.ui.blocks.left_panel':new())

  -- CenterPanel
  obj.ui_handler:addElement(require 'editor.ui.blocks.central_panel':new(base_panel_width, 0, w - 2 *
    base_panel_width, h))

  -- RightPanel
  obj.ui_handler:addElement(require 'editor.ui.blocks.right_panel':new())

  return obj;
end

---@param DirtyFlags
function RoxEditor:markDirty(flag)
  self.ui_handler:markDirty(flag)
end

function RoxEditor:draw()
  self.ui_handler:render()
end

function RoxEditor:resize()
  self.ui_handler:resize();
end

return RoxEditor
