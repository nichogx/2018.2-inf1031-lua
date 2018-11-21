local glW, glH

local lg = love.graphics

local cfgs = {
  "esc - Sair",
  "R - Recomeçar",
  "H - Habilitar/desabilitar modo help"
}

local pieces = {}

-- inicia tabuleiro vazio
local board = {
  {nil, nil, "<black><bpawn>", "<black><rook>",   "<black><fpawn>", nil, nil, nil, nil, "<white><fpawn>", "<white><rook>",   "<white><bpawn>", nil, nil},
  {nil, nil, "<black><bpawn>", "<black><knight>", "<black><fpawn>", nil, nil, nil, nil, "<white><fpawn>", "<white><knight>", "<white><bpawn>", nil, nil},
  {nil, nil, "<black><bpawn>", "<black><bishop>", "<black><fpawn>", nil, nil, nil, nil, "<white><fpawn>", "<white><bishop>", "<white><bpawn>", nil, nil},
  {nil, nil, "<black><bpawn>", "<black><king>",   "<black><fpawn>", nil, nil, nil, nil, "<white><fpawn>", "<white><king>",   "<white><bpawn>", nil, nil},
  {nil, nil, "<black><bpawn>", "<black><queen>",  "<black><fpawn>", nil, nil, nil, nil, "<white><fpawn>", "<white><queen>",  "<white><bpawn>", nil, nil},
  {nil, nil, "<black><bpawn>", "<black><bishop>", "<black><fpawn>", nil, nil, nil, nil, "<white><fpawn>", "<white><bishop>", "<white><bpawn>", nil, nil},
  {nil, nil, "<black><bpawn>", "<black><knight>", "<black><fpawn>", nil, nil, nil, nil, "<white><fpawn>", "<white><knight>", "<white><bpawn>", nil, nil},
  {nil, nil, "<black><bpawn>", "<black><rook>",   "<black><fpawn>", nil, nil, nil, nil, "<white><fpawn>", "<white><rook>",   "<white><bpawn>", nil, nil}
}

local images = {} -- tabela com as imagens

function love.load()
  --love.window.setFullscreen(true) -- //TODO HABILITAR
  love.window.setMode(1280, 720) -- 720p para testes //TODO REMOVER
  glW = lg.getWidth()
  glH = lg.getHeight()
  lg.setBackgroundColor(0.5, 0, 0)
  images = {
    white_fpawn = lg.newImage("pieces/white_fpawn.png"),
    white_bpawn = lg.newImage("pieces/white_bpawn.png"),
    white_rook = lg.newImage("pieces/white_rook.png"),
    white_knight = lg.newImage("pieces/white_knight.png"),
    white_bishop = lg.newImage("pieces/white_bishop.png"),
    white_king = lg.newImage("pieces/white_king.png"),
    white_queen = lg.newImage("pieces/white_queen.png"),
    black_fpawn = lg.newImage("pieces/black_fpawn.png"),
    black_bpawn = lg.newImage("pieces/black_bpawn.png"),
    black_rook = lg.newImage("pieces/black_rook.png"),
    black_knight = lg.newImage("pieces/black_knight.png"),
    black_bishop = lg.newImage("pieces/black_bishop.png"),
    black_king = lg.newImage("pieces/black_king.png"),
    black_queen = lg.newImage("pieces/black_queen.png")
  }
end

function love.update()
end

function love.draw() 
  lg.setColor(1, 1, 1)
  for i, v in ipairs(cfgs) do
    lg.print(v, 15, 15 * i)
  end
  
  lg.push()
  local ratio = glW/glH
  local ppH = 12 -- peça por height
  lg.scale(glW/(ratio * ppH), glH/ppH)
  lg.translate((ratio * ppH/2) - 7, (ppH - 8)/2)
  lg.setColor(200/255, 170/255, 140/255)
  lg.rectangle("fill", 0, 0, 14, 8)
  
  -- funcao que desenha quadrado do tabuleiro
  local function desRec(i, j, r, g, b)
    lg.setColor(r/255, g/255, b/255)
    lg.rectangle("fill", i - 1, j - 1, 1, 1)
  end
  
  -- desenha tabuleiro
  
  for i = 1, 8 do
    for j = 1, 14 do
      if (i + j) % 2 == 1 then
        desRec(j, i, 100, 70, 40) -- desenha retangulo
      end
      if board[i][j] then
        local _, _, teamcolor, piecetype = board[i][j]:find("<(%a+)><(%a+)>")
        lg.setColor(1, 1, 1)
        lg.draw(images[teamcolor .. "_" .. piecetype], j - 1, i - 1, 0, 0.000485)
      end
    end
  end
  
  lg.pop()
end

function love.keypressed(key, scancode, isrepeat)
  if key == "escape" then
    love.event.quit()
  end
end
