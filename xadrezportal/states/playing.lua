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

local function move(src1, src2, dest1, dest2)
	local str = string.format('<move><%s><%d><%d><%d><%d>', vars.player, src1, src2, dest1, dest2)
	msgr.sendMessage(str, 'portalchess01020304')
end

function playing.msgReceived(message)
	local _, _, msgType = message:find("<(%a+)>")
	if msgType == 'move' then
		local _, _, _, player, src1, src2, dest1, dest2 = message:find("<(%a+)><(%a+)><(%d+)><(%d+)><(%d+)><(%d+)>")
		src1 = tonumber(src1); src2 = tonumber(src2)
		dest1 = tonumber(dest1); dest2 = tonumber(dest2)
		vars.board[dest2][dest1] = vars.board[src2][src1]
		vars.board[src2][src1] = nil

		-- trocar a vez segundo critérios
		if player == 'white' then vars.turn = 'black'
		else vars.turn = 'white' end
	end
end

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
	msgr.checkMessages()
end

function playing.keypressed(key, scancode, isrepeat)
	if key == "escape" then
		vars.gameState = "menu"
	elseif key == 'r' then
		vars.resetBoard()
		vars.turn = 'white'
	end
end

-- funções estão no final
local validMove
local validMoveNoEatables
local getEatables

function playing.mousepressed(x, y, button)
	local ratio = vars.glW/vars.glH
	local ppH = 12 -- peça por height
	local x = math.floor(x/(vars.glW/(ratio * ppH)) + 1/3 + 1) - 4 -- começa no 4
	local y = math.floor(y/(vars.glH/ppH) + 1) - 2 -- começa no 2
	
	coisa = {x, y} -- TODO TIRAR
	
	if x >= 1 and x <= 14 
	and y >= 1 and y <= 8 
	and vars.turn == vars.player then
		if not selected[1] and vars.board[y][x] then -- nada selecionado, existe peça: selecionar
			local _, _, team = vars.board[y][x]:find("<(%a+)>")
			if vars.player == team then
				selected = {x, y}
			else
				selected = {}
			end
		elseif selected[1] and (y ~= selected[2] or x ~= selected[1])
		and validMove(selected[1], selected[2], x, y) then -- movimento válido, mover
			if x > 14 then x = x % 14 end			
			move(selected[1], selected[2], x, y)
			local result = validMove(selected[1], selected[2], x, y)
			if result ~= true then -- houve peça comida
				vars.board[result[2]][result[1]] = nil
			end
			selected = {}
		else -- movimento invalido, tirar selecionamento
			selected = {}
		end
	else
		selected = {}
	end
end

validMoveNoEatables = function(srcX, srcY, destX, destY)
	if (destX + destY) % 2 == 0 or vars.board[destY][destX] then 
		return false
	end	
	
	if (math.abs(srcX - destX) > 1 and math.abs(srcX - destX) < 13)
	or math.abs(srcY - destY) > 1 then
		return false
	end
	
	return true
end

getEatables = function(srcX, srcY, opt)
	local eatables = {}
	for i = 1, #opt do
		local x = opt[i][1]
		local y = opt[i][2]
		if vars.board[y][x] then
			local _, _, teamcolor = vars.board[y][x]:find("<(%a+)>")
			if teamcolor ~= vars.player
			and validMoveNoEatables(x, y, x + (x - srcX), y + (y - srcY)) then
				eatables[#eatables + 1] = {x, y, x + (x - srcX), y + (y - srcY)}
			end
		end
	end
	return eatables
end

getOptions = function(srcX, srcY)
	local opt = {}
	opt[1] = {srcX + 1, srcY + 1}
	opt[2] = {srcX - 1, srcY + 1}
	opt[3] = {srcX + 1, srcY - 1}
	opt[4] = {srcX - 1, srcY - 1}
	
	for i = 1, #opt do
		if opt[i][1] > 14 then opt[i][1] = opt[i][1] % 14 end
		if opt[i][1] < 1  then opt[i][1] = 14 - opt[i][1] end

		if opt[i][2] > 8 or opt[i][2] < 1 then
			opt[i] = nil
		end
	end

	local j=0
	for i = 1, #opt do
		if opt[i] ~= nil then
			j = j + 1
			opt[j] = opt[i]
		end
	end
	for i = j + 1, #opt do
		opt[i] = nil
	end

	return opt
end

validMove = function(srcX, srcY, destX, destY)
	local opt = getOptions(srcX, srcY)
	
	-- da pra comer?
	local eatables = getEatables(srcX, srcY, opt)
	
	if #eatables ~= 0 then
		for i = 1, #eatables do
			if destX == eatables[i][3] and destY == eatables[i][4] then
				return {eatables[i][1], eatables[i][2]}
			end
		end

		return false
	end

	-- existem outras peças que podem comer?
	for i = 1, 8 do
		for j = 1, 14 do
			if vars.board[i][j] then
				local _, _, teamcolor = vars.board[i][j]:find("<(%a+)>")
				if teamcolor == vars.player and #getEatables(j, i, getOptions(j, i)) ~= 0 then
					return false
				end
			end
		end
	end

	return validMoveNoEatables(srcX, srcY, destX, destY)
end

-- modulo
return playing
