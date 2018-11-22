-- modulo
local playing = {}

-- import modulo das variaveis
local vars = require "vars"

-- love graphics shortcut
local lg = love.graphics

--[[

Descrição do Módulo:

este módulo contém todas as funções do love para o estado
playing.
Contém:
  playing.draw()
  playing.update()
  playing.keypressed()
  playing.mousepressed()

]]--

function playing.draw()
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

function playing.update()
end

function playing.keypressed()
end

function playing.mousepressed()
end

-- modulo
return playing