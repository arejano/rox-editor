dofile("globals.lua")

local WindowManager = require "window_manager"
local RoxEditor = require "editor.rox_editor"

Handler = nil
Editor = nil

dirty = false


function love.load()
  WindowManager:init()
  Editor = RoxEditor:new()

  Handler = {
    update_size = function()
    end,
    update_focus = function(focus)
      print(focus)
    end,
    update = function(dt)
      print(dt)
    end,
  }
end

---@param focus boolean
function love.focus(focus)
  WindowManager:update_focus(Handler, focus)
end

function love.update(dt)
  -- Handler.update(dt)
end

function love.draw()
  if dirty == false then
    Editor:draw()
    -- dirty = true
  else
    return
  end

  love.graphics.rectangle("fill", 10, 10, 100, 100)
end

function love.keypressed()
end

-- Mouse
function love.mousepressed()
end

function love.mousereleased()
end

---@param focus boolean
function love.mousefocus(focus)
  WindowManager:update_focus(Handler, focus)
end

function love.resize()
  WindowManager:update_size(Handler)
end
