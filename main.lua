dofile("globals.lua")

local WindowManager = require "window_manager"

Handler = nil


function love.load()
  WindowManager:init()

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
