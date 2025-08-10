local UIElement = require("core.ui.element")
local utils = require("core.utils")
local LoveProfiler = require("love_profiler")

UI = require("ui_test")
Profiler = LoveProfiler.new()

function love.load()
  Profiler:start()

  -- utils.debug_position()
end

function love.update(dt)
  Profiler:update(dt)
end

function love.draw()
  UI:render()
  Profiler:draw()
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
  UI:handle_mouse_click(mouseData)
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
  UI:handle_mouse_click(mouseData)
end

function love.mousemoved(x, y, dx, dy, istouch)
  local mouseData = { x = x, y = y, dx = dx, dy = dy, istouch = istouch }
  UI:mouse_moved(mouseData)
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
