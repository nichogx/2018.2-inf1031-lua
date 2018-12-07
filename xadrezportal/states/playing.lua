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

local hungry = false
local points = { black = 0, white = 0 }
local winner = nil
local actFrame = 1

-- funções estão no final
local validMove
local validMoveNoEatables
local getEatables
local getOptions

local function move(src1, src2, dest1, dest2)
	local str = string.format('<move><%s><%d><%d><%d><%d>', vars.player, src1, src2, dest1, dest2)
	msgr.sendMessage(str, 'portalchess01020304')
	hungry = false
end

local function kill(x, y, team)
	local str = string.format('<kill><%s><%d><%d>', team, x, y)
	msgr.sendMessage(str, 'portalchess01020304')
	hungry = true
end

local function restart()
	local str = string.format('<restart>')
	msgr.sendMessage(str, 'portalchess01020304')
end

local function finalizar()
	local str = string.format('<end>')
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
		if not hungry or #getEatables(dest1, dest2, getOptions(dest1, dest2)) == 0 then -- não pode comer, trocar de vez
			if player == 'white' then
				vars.turn = 'black'
			else 
				vars.turn = 'white' 
			end
		end

		local _, _, player, piece = vars.board[dest2][dest1]:find("<(%a+)><(%a+)>")
		if player == 'white' and ((piece == 'reg' and dest1 <= 4) or (piece == 'breg' and dest1 >= 4 and dest1 < 12)) then
			vars.board[dest2][dest1] = '<white><crown>'
		end
		if player == 'black' and ((piece == 'reg' and dest1 >= 11) or (piece == 'breg' and dest1 <= 11 and dest1 > 3)) then
			vars.board[dest2][dest1] = '<black><crown>'
		end
	elseif msgType == 'kill' then
		local _, _, _, team, x, y = message:find("<(%a+)><(%a+)><(%d+)><(%d+)>")
		x = tonumber(x); y = tonumber(y)
		points[team] = points[team] + 1

		if points[team] >= 16 then
			winner = team
		end

		vars.board[y][x] = nil
	elseif msgType == 'restart' then
		vars.resetBoard()
		vars.turn = 'white'
		winner = nil
		points = { black = 0, white = 0 }
		hungry = false
	elseif msgType == 'end' then
		if points.black > points.white then
			winner = 'black'
		elseif points.white > points.black then
			winner = 'white'
		else
			winner = 'empate'
		end
	end
end

function playing.draw()
	lg.setColor(1, 1, 1)
	local dimW, dimH = vars.bgImages[actFrame]:getDimensions()
	lg.draw(vars.bgImages[actFrame], -200, 0, 0, vars.glW/dimW * 1.2)
	lg.setColor(0, 0, 0, 0.4) -- deixar mais escuro
	lg.rectangle("fill", 0, 0, vars.glW, vars.glH)

	lg.setFont(vars.deffont)
	lg.setColor(1, 1, 1)
	for i, v in ipairs(vars.cfgs) do
		lg.print(v, 15, 20 * i)
	end
	lg.print('WHITE: ' .. points.white .. ' pontos', 15, 20 * (#vars.cfgs + 2))
	lg.print('BLACK: ' .. points.black .. ' pontos', 15, 20 * (#vars.cfgs + 3))
	lg.print('VEZ DE: ' .. vars.turn, 15, 20 * (#vars.cfgs + 5))

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
	lg.push()
	
	-- borda
	lg.translate(vars.glW/2, vars.glH/2)
	lg.setColor(1, 1, 1)
	local borderW = vars.borderImages[1]:getWidth()
	local borderH = vars.borderImages[1]:getHeight()
	local scale = vars.glH/borderH - 2/9 * vars.glH/borderH
	lg.draw(vars.borderImages[actFrame], 0, 0, 0, scale, scale, borderW/2, borderH/2)
	
	lg.pop()
	
	if winner then
		lg.setColor(0, 0, 0, 0.7) -- cor do texto winner
		lg.rectangle("fill", 0, 0, vars.glW, vars.glH)
		if winner == 'empate' then
			vars.winnerStuff.text:set("empate!", vars.glW - 200)
		else
			vars.winnerStuff.text:set(winner .. " ganhou o jogo!", vars.glW - 200)
		end

		lg.setColor(1, 1, 1) -- cor do texto winner
		txtW, txtH = vars.winnerStuff.text:getDimensions()
		lg.draw(vars.winnerStuff.text, vars.glW/2 - txtW/2, vars.glH/2 - txtH/2 - vars.glH/10)
		txtW, txtH = vars.winnerStuff.restartText:getDimensions()
		lg.draw(vars.winnerStuff.restartText, vars.glW/2 - txtW/2, vars.glH/2 - txtH/2 + vars.glH/10)
	end
end

local dtacum = 0
function playing.update(dt)
	dtacum = dtacum + dt
	msgr.checkMessages()
	if dtacum >= 0.1 then
		actFrame = actFrame + 1
		dtacum = 0
		if actFrame > 16 then
			actFrame = 1
		end
	end
end

function playing.keypressed(key, scancode, isrepeat)
	if key == "escape" then
		vars.gameState = "menu"
	elseif key == 'r' then
		restart()
	elseif key == 'f' then
		finalizar()
	end
end

function playing.mousepressed(x, y, button)
	local ratio = vars.glW/vars.glH
	local ppH = 12 -- peça por height
	local x = math.floor(x/(vars.glW/(ratio * ppH)) + 1/3 + 1) - 4 -- começa no 4
	local y = math.floor(y/(vars.glH/ppH) + 1) - 2 -- começa no 2
	
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
			local _, _, team = vars.board[selected[2]][selected[1]]:find("<(%a+)>")
			if result ~= true then -- houve peça comida
				kill(result[1], result[2], team)
			end
			selected = {}
		else -- movimento invalido, tirar selecionamento
			selected = {}
		end
	else
		selected = {}
	end
end

validMoveNoEatables = function(srcX, srcY, destX, destY, disconsider)
	if (destX + destY) % 2 == 0 or (vars.board[destY] and vars.board[destY][destX]) then 
		return false
	end

	if destY > 8 or destY < 1 then
		return false
	end
	
	if (math.abs(srcX - destX) > 1 and math.abs(srcX - destX) < 13)
	or math.abs(srcY - destY) > 1 then
		return false
	end
	
	if not disconsider then
		local _, _, teamcolor, piecetype = vars.board[srcY][srcX]:find("<(%a+)><(%a+)>")

		if teamcolor == 'black' then
			if (piecetype == 'reg'  and (destX - srcX < 0 and destX - srcX ~= -13))
			or (piecetype == 'breg' and (destX - srcX > 0 and destX - srcX ~= 13)) then
				return false
			end
		else
			if (piecetype == 'reg'  and (destX - srcX > 0 and destX - srcX ~= 13))
			or (piecetype == 'breg' and (destX - srcX < 0 and destX - srcX ~= -13)) then
				return false
			end
		end
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

			local theX = x + (x - srcX)
			if srcX == 14 and x == 1 then
				theX = 2
			elseif srcX == 1 and x == 14 then
				theX = 13
			elseif srcX == 13 and x == 14 then
				theX = 1
			elseif srcX == 2 and x == 1 then
				theX = 14
			end

			if teamcolor ~= vars.player
			and validMoveNoEatables(x, y, theX, y + (y - srcY), true) then
				eatables[#eatables + 1] = {x, y, theX, y + (y - srcY)}
			end
		end
	end
	return eatables
end

getOptions = function(srcX, srcY)
	if not vars.board[srcY] or not vars.board[srcY][srcX] then
		return {}
	end
	
	local _, _, teamcolor, piecetype = vars.board[srcY][srcX]:find("<(%a+)><(%a+)>")
	
	local mod = 1
	if teamcolor == 'black' then mod = -1 end
	
	local opt = {}
	if piecetype ~= 'reg' then -- breg ou dama
		opt[#opt + 1] = {srcX + 1 * mod, srcY + 1}
		opt[#opt + 1] = {srcX + 1 * mod, srcY - 1}
	end
	
	if piecetype ~= 'breg' then -- reg ou dama
		opt[#opt + 1] = {srcX - 1 * mod, srcY + 1}
		opt[#opt + 1] = {srcX - 1 * mod, srcY - 1}
	end
	
	
	for i = 1, #opt do
		if opt[i][1] > 14 then opt[i][1] = opt[i][1] % 14 end
		if opt[i][1] < 1  then opt[i][1] = 14 - opt[i][1] end

		if opt[i][2] > 8 or opt[i][2] < 1 then
			opt[i] = nil
		end
	end

	local j = 0
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

	return validMoveNoEatables(srcX, srcY, destX, destY, false)
end

-- modulo
return playing
