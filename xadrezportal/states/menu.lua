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

local function newMenuText(n, option, action)
  local font = lg.newFont("resources/Lato-Font/Lato-Regular.ttf", 30)
  local text = lg.newText(font, option)
  local dimX, dimY = text:getDimensions()
  local pos = {vars.glW/2 - dimX/2, vars.glH/6 + (n + 4) * vars.glH/15}
  return { text = text, action = action, pos = pos, dimensions = {dimX, dimY} }
end

local menuoptions = {
  newMenuText(1, "iniciar", function () 
    vars.gameState = "playing"
  end),
  newMenuText(2, "sair", function () 
    love.event.quit()
  end)
}

function menu.draw()
  lg.setColor(1, 1, 1)
  local logoW, logoH = vars.genImages.logo:getDimensions();
  local scale = vars.glH/logoW * 0.6
  lg.draw(vars.genImages.logo, vars.glW/2 - (scale * logoW)/2, 2 * vars.glH/6 - (scale * logoH)/2, 0, scale)
  
  for i, v in ipairs(menuoptions) do
    lg.draw(v.text, v.pos[1], v.pos[2])
  end
end

function menu.update(dt)
end

function menu.keypressed(key, scancode, isrepeat)
	if key == "escape" then
		love.event.quit()
	end
end

function menu.mousepressed(x, y, button)
end

-- modulo
return menu