-- modulo
local drawStates = {}

-- love graphics shortcut
local lg = love.graphics

-- modulo das variaveis
local vars = require "vars"

-- função de estado LOADING
function drawStates.loading()
    -- faz um background
    lg.setColor(0, 0.4, 0.5)
    lg.rectangle("fill", 0, 0, vars.glW, vars.glH)
    
    -- faz os textos (na draw mesmo, pois como o estado loading é rápido,
    -- não justifica criar os textos fora. Não importa muito performance nesse
    -- estado)
    lg.setColor(1, 1, 1)
    local loadFont = lg.newFont("resources/Lato-Font/Lato-Regular.ttf", 30)
    local loadText = lg.newText(loadFont, "INICIANDO JOGO...")
    
    local loadStepsFont = lg.newFont("resources/Lato-Font/Lato-Light.ttf", 20)
    local loadStepsText = lg.newText(loadStepsFont, string.format("%d/%d", vars.loaded, vars.loadsteps))
    
    -- desenha os textos
    local txtW, txtH
    txtW, txtH = loadText:getDimensions()
    lg.draw(loadText, vars.glW/2 - txtW/2, vars.glH/2 - txtH/2)
    txtW, txtH = loadStepsText:getDimensions()
    lg.draw(loadStepsText, vars.glW/2 - txtW/2, vars.glH/2 - txtH/2 + vars.glH/20)
    
    -- //TODO colocar barrinha de loading
end

-- função de estado PLAYING
function drawStates.playing()
  lg.setColor(1, 1, 1)
  for i, v in ipairs(vars.cfgs) do
    lg.print(v, 15, 15 * i)
  end
  
  lg.push()
  local ratio = vars.glW/vars.glH
  local ppH = 12 -- peça por height
  lg.scale(vars.glW/(ratio * ppH), vars.glH/ppH)
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
      if vars.board[i][j] then
        local _, _, teamcolor, piecetype = vars.board[i][j]:find("<(%a+)><(%a+)>")
        lg.setColor(1, 1, 1)
        lg.draw(vars.images[teamcolor .. "_" .. piecetype], j - 1, i - 1, 0, 0.000485)
      end
    end
  end
  
  lg.pop()
end

-- modulo
return drawStates