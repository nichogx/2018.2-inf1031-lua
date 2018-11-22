-- import de modulos
local vars = require "vars"             -- modulo das variaveis
local drawStates = require "drawStates" -- modulo das funções de draw

-- love graphics shortcut
local lg = love.graphics

function love.update(dt)
	-- estado de loading
	if vars.gameState == "loading" then
		if #vars.imagesToLoad > 0 then
			local name = table.remove(vars.imagesToLoad, 1)
			vars.images[name] = lg.newImage("pieces/" .. name .. ".png");
			vars.loaded = vars.loaded + 1
			return
		end
		vars.gameState = "playing"
	end
end

function love.load()
	-- love.window.setFullscreen(true) -- //TODO HABILITAR
	love.window.setMode(1280, 720) -- 720p para testes //TODO REMOVER
	vars.glW = lg.getWidth()
	vars.glH = lg.getHeight()

	-- obs: o loading de imagens é feito na love.update() se o estado for "loading"

	lg.setBackgroundColor(0.5, 0, 0)
end

function love.draw() 
	drawStates[vars.gameState]() -- chama a função draw específica para o estado atual
end

function love.keypressed(key, scancode, isrepeat)
	if key == "escape" then
		love.event.quit()
	end
end
