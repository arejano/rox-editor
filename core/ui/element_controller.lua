local utils = require("core.utils")

local ElementController = {

}

ElementController.__index = ElementController

---@param element UIElement
function ElementController.toggle_minimize(element)
  local ww, wh = utils.GetWindowSize()
  if not element.minimized then
    -- Minimizar
    ElementController.savePosition(element)
    element.minimized = true
    element.rect.x = 10
    element.rect.y = wh - 30
    -- element:resize(100, 20)
  else
    -- Restaurar
    element.minimized = false
    ElementController.restore_last_position(element)
  end
  element:mark_dirty()
end

---@param element UIElement
function ElementController.toggle_maximize(element)
  local ww, wh = utils.GetWindowSize();

  if element.maximized then
    ElementController.restore_last_position(element)

    element.maximized = false
    element:drag_to(100, 100)
    element:setMinimalSize()
  else
    ElementController.savePosition(element)

    element.maximized = true
    element:drag_to(0, 0)
    element:resize(ww, wh)
  end

  element:mark_dirty()
end

---@param element UIElement
function ElementController.savePosition(element)
  local rect = {
    x = element.rect.x,
    y = element.rect.y,
    width = element.rect.width,
    height = element.rect.height,
  }
  element.last_float_position = rect
end

---@param element UIElement
function ElementController.restore_last_position(element)
  element.rect.x = element.last_float_position.x
  element.rect.y = element.last_float_position.y
  element:resize(element.last_float_position.width, element.last_float_position.height)
end

---@param element UIElement
function ElementController.toggle_enroll(element)
end

---@param element UIElement
function ElementController.close(element)
end

---@param element UIElement
function ElementController.horizontal_resize_childs(element)
  local parent = element.parent
  if not parent then return end

  local padding = parent.style.padding or 0
  local innerWidth = parent.rect.width - (element.parent.style.padding * 2)
  element.rect.width = innerWidth

  local childCount = #element.childs
  if childCount == 0 then return end

  local splitSize = innerWidth / childCount
  local innerHeight = element.rect.height - (element.style.padding * 2)

  for i, child in ipairs(element.childs) do
    local offset = (splitSize * (i - 1)) + element.style.padding
    child.rect.x = offset
    child.rect.y = element.style.padding
    child:resize(splitSize - (element.style.padding * 2), innerHeight)
  end
end

function ElementController.vertical_resize_childs(element)
  print(#element.childs)
end

return ElementController
