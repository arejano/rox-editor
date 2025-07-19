local utils        = require("core.utils")

local HTMLParser   = {
  files = {
    "html/index.html"
  }
}
HTMLParser.__index = HTMLParser

function HTMLParser:new()
  self = {}
  return setmetatable(self, HTMLParser)
end

function HTMLParser:readFile(path)
  local htmlContent, size = love.filesystem.read(self.files[1])
  local parsed = self:parser(htmlContent)
  -- print(utils.inspect(parsed))
end

function HTMLParser:parser(html)
  local stack = {}
  local root = { tag = "root", children = {} }
  table.insert(stack, root)

  local pos = 1
  while pos <= #html do
    local tagStart, tagEnd, closingSlash, tagName, attrStr = html:find("<(/?)(%w+)(.-)>", pos)
    print("")
    print("tagStart:", tagStart)
    print("tagEnd:", tagEnd)
    print("closingSlash:", closingSlash)
    print("closingSlash:", closingSlash)
    print("tagName:", tagName, attrStr)
    print("attrStr:", attrStr)

    if tagStart then
      -- texto entre as tags
      if tagStart > pos then
        local text = html:sub(pos, tagStart - 1):match("^%s*(.-)%s*$")
        if text ~= "" then
          table.insert(stack[#stack].children, text)
        end
      end

      if closingSlash == "/" then
        -- tag de fechamento
        if stack[#stack].tag == tagName then
          table.remove(stack) -- fecha a tag
        else
          print("Erro: fechamento fora de ordem", tagName)
        end
      else
        -- nova tag de abertura
        local node = {
          tag = tagName,
          attributes = parseAttributes(attrStr),
          children = {}
        }
        table.insert(stack[#stack].children, node)
        table.insert(stack, node) -- entra no novo nó
      end

      pos = tagEnd + 1
    else
      -- sem mais tags, o resto é texto
      local text = html:sub(pos):match("^%s*(.-)%s*$")
      if text ~= "" then
        table.insert(stack[#stack].children, text)
      end
      break
    end
  end

  return root.children[1] -- retorna o primeiro elemento real
end

function parseAttributes(attrStr)
  local attrs = {}
  for key, value in attrStr:gmatch("(%w+)%s*=%s*\"(.-)\"") do
    attrs[key] = value
  end
  return attrs
end

return HTMLParser
