local ElementController = require("core.ui.element_controller")
---@alias EventEnum
---| "minimize"
---| "maximize"
---| "close"

---@class Events
---@field minimize "minimize"
---@field maximize "maximize"
---@field close "close"
---@field handleEvent function



---@type Events
local Events = {
  minimize = "minimize",
  maximize = "maximize",
  close = "close",
  handleEvent = function() end
}


Events.handleEvent = function(event, element, data)
  local actions = {
    [Events.minimize] = function()
      ElementController.toggle_minimize(element);
    end,
    [Events.maximize] = function()
      ElementController.toggle_maximize(element);
    end,
    [Events.close] = function()
    end
  }

  local action = actions[event]

  if action then
    action()
  else
    print("Unknown event:", event)
  end
end


return Events
