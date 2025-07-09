local UiHandler = require "editor.ui_handler"
local UiElement = require "editor.ui_element"
local FloatPanel = require 'editor.ui.components.float_panel'
local Fps = require 'editor.ui.components.fps'

local FloatBox = require 'editor.ui.components.float_box'
local Rect = require "editor.ui.rect"

local editor_ui = UiHandler:new();

editor_ui.rootElement = UiElement:new(0, 0, love.graphics.getWidth(), love.graphics.getHeight())
editor_ui.rootElement.name = "RootElement"
editor_ui.rootElement.draw = function(_) end

local float_box = FloatBox(Rect.box(300, 300), nil)

editor_ui.rootElement:addChild(float_box)
editor_ui.rootElement:addChild(FloatBox({ x = 10, y = 10, width = 200, height = 200 }, nil))
editor_ui.rootElement:addChild(FloatBox({ x = 100, y = 10, width = 200, height = 200 }, nil))
editor_ui.rootElement:addChild(FloatBox({ x = 200, y = 10, width = 200, height = 200 }, nil))
editor_ui.rootElement:addChild(FloatBox({ x = 300, y = 10, width = 200, height = 200 }, nil))
editor_ui.rootElement:addChild(Fps)

local image_card = love.graphics.newImage("assets/joker_card.png")
local card = UiElement:new(0, 0, image_card:getWidth(), image_card:getHeight())
card.texture = image_card
card.isDragable = true

local image_mago = love.graphics.newImage("assets/mago_negro.jpg")
local mago = UiElement:new(0, 0, image_mago:getWidth(), image_mago:getHeight())
mago.texture = image_mago
mago.isDragable = true

editor_ui.rootElement:addChild(card)
editor_ui.rootElement:addChild(mago)

editor_ui.rootElement.canvas = nil

return editor_ui
