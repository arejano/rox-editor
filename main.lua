local UIElement = require("core.ui.element")
local utils = require("core.utils")

UI = require("ui_test")

function love.load()
  love.profiler = require("libs.profile.profile")
  love.profiler.start()


  utils.debug_position()
end

love.frame = 0
function love.update(dt)
  love.frame = love.frame + 1
  if love.frame % 60 == 0 then
    love.report = love.profiler.report(150)
    love.profiler.reset()
  end
end

function love.draw()
  love.graphics.print("WoW")
  UI:render()
  love.graphics.print(love.report or "Please wait...")
end

function love.keypressed(key)
  -- KeyboardManager:process(key, true)
end

function love.keyreleased(key)
  -- KeyboardManager:process(key, false)
end

-- Mouse
function love.mousepressed(x, y, button, istouch, presses)
  local mouseData = {
    x = x,
    y = y,
    button = button,
    istouch = istouch,
    presses = presses,
    pressed = true,
    release = false
  }
  UI:handleMouseClick(mouseData)
end

function love.mousereleased(x, y, button, istouch, presses)
  local mouseData = {
    x = x,
    y = y,
    button = button,
    istouch = istouch,
    presses = presses,
    pressed = false,
    release = true
  }
  UI:handleMouseClick(mouseData)
end

function love.mousemoved(x, y, dx, dy, istouch)
  local mouseData = { x = x, y = y, dx = dx, dy = dy, istouch = istouch }
  UI:mouseMoved(mouseData)
end

---@param focus boolean
function love.mousefocus(focus)
  -- Editor:mouseFocus(focus)
end

function love.wheelmoved(x, y)
  print(x, y)
end

function love.resize(w, h)
  UI:resize(w, h);
end
