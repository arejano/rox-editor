dofile("globals.lua")

local WindowManager = require "window_manager"
---@type RoxEditor
local RoxEditor = require "editor.rox_editor"

Handler = nil
---@type RoxEditor
Editor = nil

function love.load()
  love.graphics.setDefaultFilter("nearest", "nearest")


  WindowManager:init()
  Editor = RoxEditor:new()

  Handler = {
    -- update_size = function()
    -- end,
    -- update_focus = function(focus)
    -- end,
    -- update = function(dt)
    -- end,
  }
end

---@param focus boolean
function love.focus(focus)
  WindowManager:update_focus(focus)
end

function love.update(dt)
  -- Handler.update(dt)
end

function love.draw()
  Editor:draw()
end

function love.keypressed()
end

-- Mouse
function love.mousepressed()
end

function love.mousereleased()
end

function love.mousemoved(x, y, dx, dy)
  if Editor and Editor.mouseMoved then
    Editor:mouseMoved()
  end
end

---@param focus boolean
function love.mousefocus(focus)
  WindowManager:update_focus(focus)
end

function love.resize()
  WindowManager:update_size()
  Editor:resize();
  Editor:markDirty("Full")
end
