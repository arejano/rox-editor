local UiHandler = require "editor.ui_handler"
local UiElement = require "editor.ui_element"

local editor_ui = UiHandler:new();

editor_ui.rootElement = UiElement:new(0, 0, love.graphics.getWidth(), love.graphics.getHeight())
editor_ui.rootElement.name = "RootElement"
editor_ui.rootElement.draw = function(_)
end

local w, h = GetWindowSize();
local base_panel_width = 200
editor_ui.rootElement:addChild(require 'editor.ui.blocks.left_panel':new())

-- CenterPanel
editor_ui.rootElement:addChild(require 'editor.ui.blocks.central_panel':new(base_panel_width, 0, w - 2 *
  base_panel_width, h))

-- RightPanel
editor_ui.rootElement:addChild(require 'editor.ui.blocks.right_panel':new())


editor_ui.rootElement.canvas = nil

return editor_ui
