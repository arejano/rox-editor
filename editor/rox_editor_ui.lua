local UiHandler = require "editor.ui_handler"
local UiElement = require "editor.ui_element"
local FloatPanel = require 'editor.ui.components.float_panel'

local FloatBox = require 'editor.ui.components.float_box'
local Rect = require "editor.ui.rect"

local editor_ui = UiHandler:new();

editor_ui.rootElement = UiElement:new(0, 0, love.graphics.getWidth(), love.graphics.getHeight())
editor_ui.rootElement.name = "RootElement"
editor_ui.rootElement.draw = function(_) end

-- local float = FloatPanel:new(5, 5, 30, 30)
-- editor_ui.rootElement:addChild(float)

local float_box = FloatBox(Rect.box(300, 300), nil)
local float_box1 = FloatBox(Rect.box(300, 300), nil)
local float_box2 = FloatBox(Rect.box(300, 300), nil)
local float_box3 = FloatBox(Rect.box(300, 300), nil)

editor_ui.rootElement:addChild(float_box)
-- editor_ui.rootElement:addChild(float_box1)
-- editor_ui.rootElement:addChild(float_box2)
-- editor_ui.rootElement:addChild(float_box3)


local w, h = GetWindowSize();
local base_panel_width = 200
-- editor_ui.rootElement:addChild(require 'editor.ui.blocks.left_panel':new())

-- -- CenterPanel
-- editor_ui.rootElement:addChild(require 'editor.ui.blocks.central_panel':new(base_panel_width, 0, w - 2 * base_panel_width,
--   h))

-- -- RightPanel
-- editor_ui.rootElement:addChild(require 'editor.ui.blocks.right_panel':new())


-- local block = UiElement:new(400, 400, 200, 150)
-- block.draw = function(self)
--   -- local x, y = self:getAbsolutePosition()
--   love.graphics.setColor(love.math.colorFromBytes(54, 112, 48))
--   love.graphics.rectangle("fill", 0, 0, self.rect.width, self.rect.height)
-- end


-- local dragger = UiElement:new(5, 5, 200, 200)

-- dragger.draw = function(self)
--   love.graphics.setColor(love.math.colorFromBytes(245, 126, 66))
--   love.graphics.rectangle("fill", self.rect.x, self.rect.y, self.rect.width, self.rect.height)
-- end

-- block:addChild(dragger)

-- local toggle = require("editor.ui.components.toggle_button"):new()
-- dragger:addChild(toggle)
-- toggle.rect.x = 20
-- toggle.rect.y = 20

-- block:addChild(toggle)

-- editor_ui.rootElement:addChild(block)

editor_ui.rootElement.canvas = nil

return editor_ui
