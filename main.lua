dofile("globals.lua")


local ball = {
  x = 400,
  y = 300,
  radius = 10,
  speedX = 200,
  speedY = 150
}

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
  Editor:update(dt)

  ball.x = ball.x + ball.speedX * dt
  ball.y = ball.y + ball.speedY * dt

  -- Colisão com bordas horizontais
  if ball.x - ball.radius < 0 then
    ball.x = ball.radius
    ball.speedX = -ball.speedX
  elseif ball.x + ball.radius > love.graphics.getWidth() then
    ball.x = love.graphics.getWidth() - ball.radius
    ball.speedX = -ball.speedX
  end

  -- Colisão com bordas verticais
  if ball.y - ball.radius < 0 then
    ball.y = ball.radius
    ball.speedY = -ball.speedY
  elseif ball.y + ball.radius > love.graphics.getHeight() then
    ball.y = love.graphics.getHeight() - ball.radius
    ball.speedY = -ball.speedY
  end
end

function love.draw()
  love.graphics.setColor(1, 1, 1)
  love.graphics.circle("fill", ball.x, ball.y, ball.radius)

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
  
  local mouseData = {
    x = x,
    y = y,
  }
  Editor:mouseMoved(mouseData)
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
