local UiHandler = require "editor.ui_handler"
local UiElement = require "editor.ui_element"
local FloatPanel = require 'editor.ui.components.float_panel'

local FloatBox = require 'editor.ui.components.float_box'
local Rect = require "editor.ui.rect"

local editor_ui = UiHandler:new();

editor_ui.rootElement = UiElement:new(0, 0, love.graphics.getWidth(), love.graphics.getHeight())
editor_ui.rootElement.name = "RootElement"
editor_ui.rootElement.draw = function(_) end

local float_box = FloatBox(Rect.box(300, 300), nil)

editor_ui.rootElement:addChild(float_box)


editor_ui.rootElement.canvas = nil

return editor_ui
