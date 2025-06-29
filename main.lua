dofile("globals.lua")

local WindowManager = require "window_manager"
---@type RoxEditor
local RoxEditor = require "editor.rox_editor"

---@type RoxEditor
Editor = nil

function love.load()
  -- debug_position()


  GlobalState = require 'global_state':new()

  GlobalState:set("ui/theme", {
    primary = "#3498db",
    secondary = "#FFFFFF",
  })

  WindowManager:init()
  Editor = RoxEditor:new()
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
  Editor:mousePressed()
end

function love.mousereleased()
end

function love.mousemoved(x, y, dx, dy)
  Editor:mouseMoved()
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

function debug_position()
  local w, h, target = GetDisplayInfo()
  love.window.setMode(
    w,
    h,
    { display = target, resizable = true }
  )
end
