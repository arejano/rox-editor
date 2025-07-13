---@enum ResizeMode
local ResizeMode = {
  NONE = "none",
  LEFT = "left",
  RIGHT = "right",
  TOP = "top",
  BOTTOM = "bottom",
  HORIZONTAL_CENTER = "horizontal_center", -- Novo modo
  VERTICAL_CENTER = "vertical_center",
  ALL = "all"
}

---@class UiThemeData
---@field primary string
---@field secondary string

---@class MouseClickData
---@field x number
---@field y number
---@field button number
---@field istouch boolean
---@field pressed boolean
---@field release boolean


return ResizeMode
