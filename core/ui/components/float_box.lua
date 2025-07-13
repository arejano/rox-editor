local UiElement = require "editor.ui_element"
local Button = require 'editor.ui.components.button'
local Text = require 'editor.ui.components.text'
local Resizer = require "editor.ui.components.resizer"
local Row = require "editor.ui.components.row"
local TinyButton = require "editor.ui.components.tiny_button"
local Container = require "editor.ui.components.container"
local Window = require "editor.ui.components.base_window"

local br = { x = 0, y = 0, width = 100, height = 100 }
local sr = { x = 0, y = 0, width = 100, height = 100 }


---@param rect Rect
---@param props FloatBoxProperties
local float_box = function(rect, props)
  local w = 450
  local h = 600

  local window = Window(w, h)
  local container = Container(0, 38, 10, 10)


  window:addChild(container)


  return window
end

return float_box
