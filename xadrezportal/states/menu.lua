-- modulo
local menu = {}

-- import modulo das variaveis
local vars = require "vars"

-- love graphics shortcut
local lg = love.graphics

--[[

Descrição do Módulo:

este módulo contém todas as funções do love para o estado
menu.
Contém:
  menu.draw()
  menu.update()
  menu.keypressed()
  menu.mousepressed()

]]--
local menuoptions
local function newMenuText(n, option, action)
	local font = lg.newFont("resources/Lato-Font/Lato-Regular.ttf", 30)
	local text = lg.newText(font, option)
	local dimX, dimY = text:getDimensions()
	local pos = {vars.glW/2 - dimX/2, vars.glH/6 + (n + 4) * vars.glH/15}
	return { text = text, action = action, pos = pos, 
					 dimensions = {dimX, dimY}, selected = false }
	
end

menuoptions = {
	newMenuText(1, "iniciar", function ()
		vars.gameState = "playing"
	end),
	newMenuText(2, "sair", function ()
		love.event.quit()
	end),
	newMenuText(3, "player: " .. vars.player, function ()
		if vars.player == 'white' then vars.player = 'black'
		else vars.player = 'white' end

		menuoptions[3].text:set('player: ' .. vars.player)
	end),
	newMenuText(4, "fullscreen: " .. tostring(vars.fullscreen), function () -- // TODO deixar bom ou tirar
		vars.fullscreen = not vars.fullscreen
		if vars.fullscreen then
			vars.glW, vars.glH = lg.getDimensions()
			love.window.setMode(vars.glW, vars.glH)
		else
			love.window.setMode(1280, 720)
		end
		love.window.setFullscreen(vars.fullscreen)

		menuoptions[4].text:set('fullscreen: ' .. tostring(vars.fullscreen))
	end),
}
menuoptions[1].selected = true;

function menu.draw()
	lg.setColor(1, 1, 1)
	local logoW, logoH = vars.genImages.logo:getDimensions();
	local scale = vars.glH/logoW * 0.6
	lg.draw(vars.genImages.logo, vars.glW/2 - (scale * logoW)/2, 2 * vars.glH/6 - (scale * logoH)/2, 0, scale)
  
	for i, v in ipairs(menuoptions) do
		if v.selected then
			lg.setColor(0, 0, 0)
			lg.rectangle("fill", v.pos[1], v.pos[2], v.dimensions[1], v.dimensions[2])
		end
		lg.setColor(1, 1, 1)
		lg.draw(v.text, v.pos[1], v.pos[2])
	end
end

function menu.update(dt)
end

function menu.keypressed(key, scancode, isrepeat)
	local function moveDown(int)
		for i, v in ipairs(menuoptions) do
			local newPos = i + int
			if v.selected then
				if newPos < 1 then
					newPos = #menuoptions
				end
				
				if newPos > #menuoptions then
					newPos = 1
				end
				
				v.selected = false
				menuoptions[newPos].selected = true
				break;
			end
		end
	end
	
	if key == "down" then
		moveDown(1)
	elseif key == "up" then
		moveDown(-1)
	elseif key == "return" then
		for i, v in ipairs(menuoptions) do
			if v.selected then
				v.action()
			end
		end
	end
end

function menu.mousepressed(x, y, button)
end

-- modulo
return menu
