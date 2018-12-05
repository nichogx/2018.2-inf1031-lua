-- modulo
local loading = {}

-- import modulo das variaveis
local vars = require "vars"

-- love graphics shortcut
local lg = love.graphics

--[[

Descrição do Módulo:

este módulo contém todas as funções do love para o estado
loading.
Contém:
  loading.draw()
  loading.update()
  loading.keypressed()
  loading.mousepressed()

]]--

function loading.draw()
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
	local loadStepsText
	if percLoad < 0.999 then
		loadStepsText = lg.newText(loadStepsFont, string.format("%d/%d (%d%%)", vars.loaded, vars.loadsteps, (percLoad) * 100))
	else
		loadStepsText = lg.newText(loadStepsFont, "conectando ao servidor...")
	end

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

function loading.update(dt)
	if not vars.winnerStuff.font then
		vars.winnerStuff.font = lg.newFont("resources/Lato-Font/Lato-Black.ttf", 100)
		vars.loaded = vars.loaded + 1
		return
	end

	if not vars.winnerStuff.text then
		vars.winnerStuff.text = lg.newText(vars.winnerStuff.font, "<no_winner>")
		vars.loaded = vars.loaded + 1
		return
	end

	if not vars.winnerStuff.restartFont then
		vars.winnerStuff.restartFont = lg.newFont("resources/Lato-Font/Lato-Black.ttf", 40)
		vars.loaded = vars.loaded + 1
		return
	end

	if not vars.winnerStuff.restartText then
		vars.winnerStuff.restartText = lg.newText(vars.winnerStuff.restartFont, "aperte R para recomeçar")
		vars.loaded = vars.loaded + 1
		return
	end

	if not vars.deffont then
		vars.deffont = lg.newFont("resources/Lato-Font/Lato-Regular.ttf", 18)
		vars.loaded = vars.loaded + 1
		return
	end
	
	if #vars.bgImages < 16 then
		vars.bgImages[#vars.bgImages + 1] = lg.newImage("resources/background/" .. #vars.bgImages .. ".png");
		vars.loaded = vars.loaded + 1
		return
	end

	if #vars.genImagesToLoad > 0 then
		local name = table.remove(vars.genImagesToLoad, 1)
		vars.genImages[name] = lg.newImage("resources/" .. name .. ".png")
		vars.loaded = vars.loaded + 1
		return
	end

	if #vars.pieceImagesToLoad > 0 then
		local name = table.remove(vars.pieceImagesToLoad, 1)
		vars.pieceImages[name] = lg.newImage("resources/pieces/" .. name .. ".png");
		vars.loaded = vars.loaded + 1
		return
  	end

	math.randomseed(os.time())
	msgr.start("portalchess01020304" .. math.random(9999), "portalchess01020304",  msgReceived)

	assert(vars.loaded == vars.loadsteps, "Não foi possível completar o processo de carregamento.")
	vars.gameState = "menu" -- mandar para o menu após load
end

function loading.keypressed(key, scancode, isrepeat)
end

function loading.mousepressed(x, y, button)
end

-- modulo
return loading
