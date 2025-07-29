local socket = require("socket")
local utils = require("core.utils")
local ecs = require("core.ecs.ecs")

function love.load()
  ecs = ecs:new()
  -- Configura o servidor para escutar na porta 12345
  server = socket.bind("127.0.0.1", 12345)
  server:settimeout(0) -- Não bloquear a execução
  print("Servidor iniciado. Aguardando conexão...")

  messages = {}
  msg = ""
  love.window.setPosition(0, 30)
end

function love.update(dt)
  -- Aceita conexões de clientes
  local client = server:accept()
  if client then
    print("Cliente conectado!")
    client:settimeout(0)
    clients = clients or {}
    table.insert(clients, client)
  end

  -- Recebe mensagens dos clientes
  if clients then
    for i, client in ipairs(clients) do
      local msg, err = client:receive()
      if msg then
        -- table.insert(messages, msg)
        -- print("Mensagem recebida:", msg)
        msg = msg
      elseif err == "closed" then
        table.remove(clients, i)
      end
    end
  end
end

function love.draw()
  -- Mostra as mensagens recebidas
  -- for i, msg in ipairs(messages) do
  --   love.graphics.print(msg, 10, 30 * (i - 1))
  -- end
  love.graphics.print(utils.inspect(msg), 10, 10)
end

function love.quit()
  if server then server:close() end
  if clients then
    for _, client in ipairs(clients) do
      client:close()
    end
  end
end
