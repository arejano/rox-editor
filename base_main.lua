-- local WindowManager = require "window_manager"
local _Editor = require "editor.editor"
local _KeyboardManager = require("core.keyboard_manager")
local _eventManager = require("core.events")
local utils = require("core.utils")

local socket = require("socket")

local AppState = require("app_state")

local tri_game = require("games.triangle_wars.game")

-- Sempre primeiro os eventos
EventManager = _eventManager:new()

---@type Editor
Editor = _Editor:new()
KeyboardManager = _KeyboardManager:new()
State = AppState:new()

-- local client = nil

function love.load()
  client = socket.connect("127.0.0.1", 12345)

  if not client then
  print("Erro ao conectar ao servidor de profiler.")
  else
  print("Conectado ao servidor de profiler com sucesso.")
  end

  love.profiler = require("libs.profile.profile")
  love.profiler.start()


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

love.frame = 0
function love.update(dt)
  love.frame = love.frame + 1
  if love.frame % 60 == 0 then
    love.report = love.profiler.report(150)
    client:send(love.report)
    love.profiler.reset()
  end


  GAME:update(dt)
end

function love.draw()
  local w, h = utils.GetWindowSize()
  love.graphics.setColor(love.math.colorFromBytes(39, 37, 36))
  love.graphics.rectangle("fill", 0, 0, w, h)

  GAME:draw()
  Editor:draw()


  -- love.graphics.print(love.timer.getFPS(), 10, 10)
  love.graphics.print(love.report or "Please wait...")
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
