-- local WindowManager = require "window_manager"
local Editor = require "editor.editor"


---@type RoxEditor
Editor = Editor:new()

function love.load()
  -- love.mouse.setGrabbed(true) -- Tranca o mouse
end

---@param focus boolean
function love.focus(focus)
  print(focus)
end

function love.update(dt)
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
