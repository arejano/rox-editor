local Rect = {}
Rect.__index = Rect

function Rect:new(x, y, w, h)
  local self = {
    x = x,
    y = y,
    w = w,
    h = h,
  }

  return self
end

function Rect.box(x, y)
  return {
    x = x,
    y = y,
    w = 100,
    h = 100,
  }
end

return Rect
