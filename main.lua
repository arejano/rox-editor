-- local WindowManager = require "window_manager"
local _Editor = require "editor.editor"
local _KeyboardManager = require("core.keyboard_manager")
local _eventManager = require("core.events")
local utils = require("core.utils")

local AppState = require("app_state")

local tri_game = require("games.triangle_wars.triangle_wars")

-- Sempre primeiro os eventos
EventManager = _eventManager:new()

---@type Editor
Editor = _Editor:new()
KeyboardManager = _KeyboardManager:new()
State = AppState:new()

function love.load()
  utils.debug_position()
  KeyboardManager:registerHandler(State)

  GAME = tri_game:new()
  State.Game = GAME
  State.Editor = Editor
  State.handler_focus = Editor
end

---@param focus boolean
function love.focus(focus)
  print(focus)
end

function love.update(dt)
  GAME:update(dt)
end

function love.draw()
  GAME:draw()
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
  Editor:mousePressed(x, y, button, istouch, presses)
end

function love.mousereleased(x, y, button, istouch, presses)
  Editor:mouseReleased(x, y, button, istouch, presses)
end

function love.mousemoved(x, y, dx, dy, istouch)
  local mouseData = { x = x, y = y, dx = dx, dy = dy, istouch = istouch }
  Editor:mouseMoved(mouseData)
end

---@param focus boolean
function love.mousefocus(focus)
  Editor:mouseFocus(focus)
end

function love.wheelmoved(x, y)
  print(x, y)
end

function love.resize(w, h)
  Editor:resize(w, h);
end
