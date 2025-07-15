-- local WindowManager = require "window_manager"
local _Editor = require "editor.editor"
local _KeyboardManager = require("core.keyboard_manager")
local _eventManager = require("core.events")

-- Sempre primeiro os eventos
EventManager = _eventManager:new()

---@type RoxEditor
Editor = _Editor:new()
KeyboardManager = _KeyboardManager:new()

function love.load()
  -- love.mouse.setGrabbed(true) -- Tranca o mouse
end

---@param focus boolean
function love.focus(focus)
  print(focus)
end

function love.update(dt)
  Editor:update(dt)
end

function love.draw()
  Editor:draw()
end

function love.keypressed(key)
  KeyboardManager:process(key, true)
end

function love.keyreleased(key)
  KeyboardManager:process(key, false)
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
  Editor:mouseFocus(focus)
end

function love.wheelmoved(x, y)
end

function love.resize(w, h)
  Editor:resize(w, h);
end
