local glW, glH

local lg = love.graphics

local cfgs = {
  "esc - Sair",
  "R - Recomeçar",
  "H - Habilitar/desabilitar modo help"
}

function love.load()
  love.window.setFullscreen(true)
  glW = lg.getWidth()
  glH = lg.getHeight()
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
  lg.translate((ratio * ppH/2) - 8, (ppH - 8)/2)
  lg.setColor(200/255, 170/255, 140/255)
  lg.rectangle("fill", 0, 0, 16, 8)
  
  local function desRec(i, j, r, g, b)
    lg.setColor(r/255, g/255, b/255)
    lg.rectangle("fill", i, j, 1, 1)
  end
  
  local function desCirc(i, j, r, g, b)
    lg.setColor(r/255, g/255, b/255)
    lg.circle("fill", i + 0.5, j + 0.5, 0.4)
  end
  -- itera linhas (j) e colunas (i)
  for i = 0, 15 do
    for j = 0, 7 do
      if (i + j) % 2 == 0 then
        desRec(i, j, 100, 70, 40) -- desenha retangulo
        if j <= 2 then
          desCirc(i, j, 0, 0, 0) -- desenha peÃ§a preta
        elseif j >= 5 then
          desCirc(i, j, 255, 255, 255) -- desenha peÃ§a branca
        end
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
