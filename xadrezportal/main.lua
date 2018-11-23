-- import de modulos
local vars = require "vars"             -- modulo das variaveis

-- love graphics shortcut
local lg = love.graphics

--[[ 

configura estados e importa os respectivos módulos

Para cada estado, deverá haver um arquivo states/<estado>.lua
que contém uma função draw(), uma update(), uma keypressed() e
uma mousepressed(), mesmo que vazias.

]]--
local stateList = {"loading", "menu", "playing"}
local states = {}

function love.update(dt)
	states[vars.gameState].update(dt) -- chama a função update específica para o estado atual
end

function love.load()
	-- love.window.setFullscreen(true) -- //TODO HABILITAR
	love.window.setMode(1280, 720) -- 720p para testes //TODO REMOVER
	vars.glW = lg.getWidth()
	vars.glH = lg.getHeight()

	for i, v in ipairs(stateList) do
		states[v] = require ("states/" .. v)
		assert(states[v].draw, "draw não encontrada no arquivo " .. v .. ".lua")
		assert(states[v].update, "update não encontrada no arquivo " .. v .. ".lua")
		assert(states[v].keypressed, "keypressed não encontrada no arquivo " .. v .. ".lua")
		assert(states[v].mousepressed, "mousepressed não encontrada no arquivo " .. v .. ".lua")
	end

	lg.setBackgroundColor(0.5, 0, 0)
end

function love.draw() 
	states[vars.gameState].draw() -- chama a função draw específica para o estado atual
end

function love.keypressed(key, scancode, isrepeat)
	states[vars.gameState].keypressed(key, scancode, isrepeat) -- chama a função keypressed específica para o estado atual
end

function love.mousepressed(x, y, button)
	states[vars.gameState].mousepressed(x, y, button) -- chama a função mousepressed específica para o estado atual
end
