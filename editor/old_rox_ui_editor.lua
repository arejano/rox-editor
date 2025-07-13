local UiHandler = require "editor.ui_handler"
local UiElement = require "editor.ui_element"
local FloatPanel = require 'editor.ui.components.float_panel'
local Fps = require 'editor.ui.components.fps'
local Resizer = require "editor.ui.components.resizer"
local Window = require 'editor.ui.components.window'

local FloatBox = require 'editor.ui.components.float_box'
local Rect = require "editor.ui.rect"

local editor_ui = UiHandler:new();

editor_ui.rootElement = UiElement:new(0, 0, love.graphics.getWidth(), love.graphics.getHeight())
editor_ui.rootElement.name = "RootElement"
editor_ui.rootElement.style.bg = { 21, 23, 24 }

editor_ui.rootElement.draw = function(self)
  love.graphics.setColor(love.math.colorFromBytes(self.style.bg))
  love.graphics.rectangle("fill", 0, 0, self.rect.width, self.rect.height, 12, 12)
end

editor_ui.rootElement:addChild(Fps)

local image_card = love.graphics.newImage("assets/joker_card.png")
local card = UiElement:new(200, 100, image_card:getWidth(), image_card:getHeight())
card.name = "Coringa"
card.texture = image_card
card.isDragable = true

local image_mago = love.graphics.newImage("assets/mago_negro.jpg")
local mago = UiElement:new(700, 100, image_mago:getWidth(), image_mago:getHeight())
mago.texture = image_mago
mago.name = "Mago"
mago.isDragable = true

local tool_window = Window:new()
editor_ui.rootElement:addChild(tool_window)

-- editor_ui.rootElement:addChild(card)
-- editor_ui.rootElement:addChild(mago)

editor_ui.rootElement.canvas = nil

return editor_ui
