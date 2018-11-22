-- modulo
local drawStates = {}

--[[

Descrição do Módulo:

este módulo contém todas as funções de draw que serão chamadas
pela draw do love dependendo do estado do programa.
Os estados aceitos são:
 - loading
 - playing
 - menu // TODO IMPLEMENTAR
 // TODO COLOCAR TODOS OS ESTADOS ACEITOS

]]--

-- love graphics shortcut
local lg = love.graphics

-- modulo das variaveis
local vars = require "vars"

-- função de estado LOADING
function drawStates.loading()
	local percLoad = vars.loaded/vars.loadsteps

	-- desenha background da tela de loading
	lg.setColor(0, 0.4, 0.5) -- cor sólida da tela de loading
	lg.rectangle("fill", 0, 0, vars.glW, vars.glH)

	-- faz os textos (na draw mesmo, pois como o estado loading é rápido,
	-- não justifica criar os textos fora. Não importa muito performance nesse
	-- estado)
	local loadFont = lg.newFont("resources/Lato-Font/Lato-Regular.ttf", 30)
	local loadText = lg.newText(loadFont, "INICIANDO JOGO...")

	local loadStepsFont = lg.newFont("resources/Lato-Font/Lato-Light.ttf", 20)
	local loadStepsText = lg.newText(loadStepsFont, string.format("%d%%", (percLoad) * 100))

	-- desenha o texto loading
	local txtW, txtH
	lg.setColor(1, 1, 1) -- cor do texto loading
	txtW, txtH = loadText:getDimensions()
	lg.draw(loadText, vars.glW/2 - txtW/2, vars.glH/2 - txtH/2)

	-- desenha barra de loading
	lg.setColor(0.9, 0.9, 0.9) -- cor da barra externa
	local extBarW = vars.glW/3;
	local extBarH = vars.glH/20;
	lg.rectangle("fill", vars.glW/2 - extBarW/2, vars.glH/2 - extBarH/2 + vars.glH/18, extBarW, extBarH);
	lg.setColor(0.6, 0.6, 0.6) -- cor da barra interna
	local intBarW = vars.glW/3 - 10; 
	local intBarH = vars.glH/20 - 10;
	lg.rectangle("fill", vars.glW/2 - intBarW/2, vars.glH/2 - intBarH/2 + vars.glH/18, intBarW * percLoad, intBarH);

	-- desenha texto da porcentagem de loading
	lg.setColor(0, 0, 0); -- cor da porcentagem de loading
	txtW, txtH = loadStepsText:getDimensions()
	lg.draw(loadStepsText, vars.glW/2 - txtW/2, vars.glH/2 - txtH/2 + vars.glH/18)
end

-- função de estado MENU
function drawStates.menu()
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
