local utils = require("core.utils")
local ElementController = require("core.ui.element_controller")
local Events = require("core.ui.events")

local UIElement = require "core.ui.element"
-- local Resizer = require "editor.ui.components.resizer"
-- local Row = require "editor.ui.components.row"
-- local Text = require "editor.ui.components.text"

local Window = {
  container_focus = nil
}
Window.__index = Window

function Window:new(x)
  local element = UIElement:new(10, 10, 300, 600)
  element.minHeight = 600
  element.minWidth = 300
  element.dragable = true

  local data = {
    state = {
      enrolled = false,
      minimize = false,
      maximized = false
    }
  }
  element:bindData(data)
  ---@param self UIElement
  ---@param event Events
  element.consumeEvent = function(self, event)
    print("COnsumindo", self)
    Events.handleEvent(event, self)
  end


  local enroll_button = UIElement:new(8, 8, 16, 16)
  enroll_button.clickable = true

  enroll_button.draw = function(self)
    local w, h = self.rect.width, self.rect.height
    local rx, ry = 0, 0
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 0, 0, w, h, rx, ry)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", 0, 0, w, h, rx, ry)
    love.graphics.print("E", 4, 0)
  end

  enroll_button.click = function(self, event)
    print("enroll_click")
    if not event.pressed then return end
    if self.parent.data.state.enrolled then
      self.parent.data.state.enrolled = false
      self.parent.container_focus.visible = true
    else
      self.parent.data.state.enrolled = true
      self.parent.container_focus.visible = false
    end

    self.parent.rect.height = self.parent.data.state.enrolled and 36 or 600

    self.parent.data.state.minimized = false
    self.parent.data.state.maximized = false
    self.parent:mark_dirty()
  end
  element:add_child(enroll_button)



  local minimize_button = UIElement:new(8, 8, 16, 16)
  minimize_button.clickable = true
  minimize_button.start = function(self)
    self.rect.x = self.parent.rect.width - self.rect.width - 12 - 16 - 16 - 16
  end

  minimize_button.watch_resize = function(self)
    self.rect.x = self.parent.rect.width - self.rect.width - 12 - 16 - 16 - 16
  end

  minimize_button.draw = function(self)
    local w, h = self.rect.width, self.rect.height
    local rx, ry = 0, 0
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 0, 0, w, h, rx, ry)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", 0, 0, w, h, rx, ry)
    love.graphics.print("M", 3, 0)
  end
  minimize_button.click = function(self, event)
    if not event.pressed then return end
    ElementController.toggle_minimize(self.parent)

    -- if not event.pressed then return end
    -- if self.parent.data.state.enrolled then
    --   self.parent.data.state.enrolled = false
    --   self.parent.container_focus:toggleVisibility(true)
    -- else
    --   self.parent.data.state.enrolled = true
    --   self.parent.container_focus:toggleVisibility(false)
    -- end

    -- self.parent.rect.height = self.parent.data.state.enrolled and 36 or 600

    -- self:toggleMinimized(self.parent)
    print("Tentando minimizar")
  end
  element:add_child(minimize_button)


  local maximize_button = UIElement:new(8, 8, 16, 16)
  maximize_button.clickable = true

  maximize_button.draw = function(self)
    local w, h = self.rect.width, self.rect.height
    local rx, ry = 0, 0
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 0, 0, w, h, rx, ry)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", 0, 0, w, h, rx, ry)
    love.graphics.print("M", 3, 0)
  end
  maximize_button.start = function(self)
    self.rect.x = self.parent.rect.width - self.rect.width - 12 - 16 - 8
  end
  maximize_button.watch_resize = function(self)
    self.rect.x = self.parent.rect.width - self.rect.width - 12 - 16 - 8
  end
  maximize_button.click = function(self, mousedata)
    if not mousedata.pressed then return end
    ElementController.toggle_maximize(self.parent)
    -- Events.handleEvent(Events.maximize, self.parent)
  end
  element:add_child(maximize_button)


  local close_button = UIElement:new(8, 8, 16, 16)
  close_button.clickable = true
  close_button.draw = function(self)
    local w, h = self.rect.width, self.rect.height
    local rx, ry = 0, 0
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 0, 0, w, h, rx, ry)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", 0, 0, w, h, rx, ry)
    love.graphics.print("C", 4, 0)
  end
  close_button.click = function(self)
    self.parent.data.state.minimized = false
    self.parent.data.state.maximized = false
    self.parent.data.state.enrolled = false
    self.parent:mark_dirty()
  end
  close_button.start = function(self)
    self.rect.x = self.parent.rect.width - self.rect.width - 12
  end
  close_button.watch_resize = function(self)
    self.rect.x = self.parent.rect.width - self.rect.width - 12
  end

  element:add_child(close_button)

  element.draw = function(self)
    local x, y = self.rect.x, self.rect.y
    local w, h = self.rect.width, self.rect.height
    local rx, ry = 0, 0 -- borda arredondada


    -- Sombra (deslocada e com alpha baixo)
    love.graphics.setColor(0, 0, 0, 0.2) -- preto com 20% de opacidade
    love.graphics.rectangle("fill", 0, 0, w, h, rx, ry)

    -- Retângulo principal
    love.graphics.setColor(love.math.colorFromBytes(0, 92, 75))
    -- love.graphics.setColor(0.1, 0.1, 0.1, 0.95)
    love.graphics.rectangle("fill", 0, 0, w - 4, h - 4, rx, ry)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("line", 0, 0, w - 4, h - 4, rx, ry)

    -- if not self.data.state.enrolled then
    --   love.graphics.setColor(1, 1, 1)
    --   love.graphics.print(utils.inspect(self.data), 0, 0)
    -- end
  end

  local container = UIElement:new(8, 32, 50, 50)
  container.start = function(self)
    self.rect.width = self.parent.rect.width - 20
    self.rect.height = self.parent.rect.height - 40
  end

  container.watch_resize = function(self)
    self.rect.width = self.parent.rect.width - 20
    self.rect.height = self.parent.rect.height - 40
  end
  element.container_focus = container

  element:add_child(container)

  return element
end

return Window
