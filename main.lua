dofile("globals.lua")

local WindowManager = require "window_manager"
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
function love.mousepressed(x, y, button, istouch, presses)
  -- button 1:left 2:right 3:wheel
  --presses quantidade de cliques no botao
  ---@type MouseClickData
  local mouseData = {
    x = x,
    y = y,
    button = button,
    istouch = istouch,
    presses = presses,
    pressed = true,
    release = false
  }
  Editor:mousePressed(mouseData)
end

function love.mousereleased(x, y, button, istouch, presses)
  ---@type MouseClickData
  local mouseData = {
    x = x,
    y = y,
    button = button,
    istouch = istouch,
    presses = presses,
    pressed = false,
    release = true
  }
  Editor:mouseReleased(mouseData)
end

function love.mousemoved(x, y, dx, dy, istouch)
  Editor:mouseMoved()
end

---@param focus boolean
function love.mousefocus(focus)
  WindowManager:update_focus(focus)
end

function love.wheelmoved(x, y)
  WindowManager:update_focus(focus)
end

function love.resize()
  WindowManager:update_size()
  Editor:resize();
  Editor.ui_handler:markDirty("Full")
end

function debug_position()
  local w, h, target = GetDisplayInfo()
  love.window.setMode(
    w,
    h,
    { display = target, resizable = true }
  )
end
