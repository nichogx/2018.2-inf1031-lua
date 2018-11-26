-- modulo
local playing = {}

-- import modulo das variaveis
local vars = require "vars"

-- love graphics shortcut
local lg = love.graphics

-- vars
local selected = {}

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

local coisa = {0, 0} -- TODO TIRAR

function playing.draw()
	lg.setColor(1, 1, 1)
	for i, v in ipairs(vars.cfgs) do
		lg.print(v, 15, 15 * i)
	end
	lg.print(coisa[1], 15, 15 * 5)
	lg.print(coisa[2], 15, 15 * 6) -- TODO TIRAR

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

	if selected[1] then desRec(selected[1], selected[2], 0, 128, 128) end -- desenha retangulo
	
	for i = 1, 8 do
		for j = 1, 14 do
			if (i + j) % 2 == 1 and (selected[1] ~= j or selected[2] ~= i) then
				desRec(j, i, 100, 70, 40) -- desenha retangulo
			end
			if vars.board[i][j] then
				local _, _, teamcolor, piecetype = vars.board[i][j]:find("<(%a+)><(%a+)>")
				lg.setColor(1, 1, 1)
				lg.draw(vars.pieceImages[teamcolor .. "_" .. piecetype], j - 1, i - 1, 0, 0.000485)
			end
		end
	end

	lg.pop()
end

function playing.update(dt)
end

function playing.keypressed(key, scancode, isrepeat)
	if key == "escape" then
		vars.gameState = "menu"
	elseif key == 'r' then
		vars.resetBoard()
	end
end

function playing.mousepressed(x, y, button)
	local ratio = vars.glW/vars.glH
	local ppH = 12 -- peça por height
	local x = math.floor(x/(vars.glW/(ratio * ppH)) + 1/3 + 1) - 4 -- começa no 4
	local y = math.floor(y/(vars.glH/ppH) + 1) - 2 -- começa no 2
	
	coisa = {x, y} -- TODO TIRAR
	
	if x >= 1 and x <= 14 
	and y >= 1 and y <= 8 then
		if not selected[1] and vars.board[y][x] then -- nada selecionado, existe peça: selecionar
			selected = {x, y}
		elseif selected[1] and (y ~= selected[2] or x ~= selected[1]) and true then -- movimento válido, mover
			vars.board[y][x] = vars.board[selected[2]][selected[1]]
			vars.board[selected[2]][selected[1]] = nil
			selected = {}
		else -- movimento invalido, tirar selecionamento
			selected = {}
		end
	else
		selected = {}
	end
end

-- modulo
return playing