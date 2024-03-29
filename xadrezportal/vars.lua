-- modulo
local vars = {}

--[[

Descrição do Módulo:

com o objetivo de não utilizar em excesso variáveis globais,
esse módulo guarda todas as variáveis comuns a mais de um módulo
a serem utilizadas no código

]]--

vars.glW = 0
vars.glH = 0

vars.player = 'white'
vars.turn   = 'white'

vars.cfgs = {
	"esc - Sair",
	"R - Recomeçar",
	"F - Finalizar jogo"
}

-- coloca no estado inicial
vars.gameState = "loading"

vars.board = {} -- tabuleiro (indexado ao contrário do love: primeiro linha, depois coluna)
function vars.resetBoard()
	vars.board = { -- tabuleiro (indexado ao contrário do love: primeiro linha, depois coluna)
		{nil, nil, nil, "<black><reg>", nil, "<black><reg>", nil, nil, nil, "<white><reg>", nil, "<white><breg>", nil, nil},
		{nil, nil, "<black><breg>", nil, "<black><reg>", nil, nil, nil, "<white><reg>", nil, "<white><reg>", nil, nil, nil},
		{nil, nil, nil, "<black><reg>", nil, "<black><reg>", nil, nil, nil, "<white><reg>", nil, "<white><breg>", nil, nil},
		{nil, nil, "<black><breg>", nil, "<black><reg>", nil, nil, nil, "<white><reg>", nil, "<white><reg>", nil, nil, nil},
		{nil, nil, nil, "<black><reg>", nil, "<black><reg>", nil, nil, nil, "<white><reg>", nil, "<white><breg>", nil, nil},
		{nil, nil, "<black><breg>", nil, "<black><reg>", nil, nil, nil, "<white><reg>", nil, "<white><reg>", nil, nil, nil},
		{nil, nil, nil, "<black><reg>", nil, "<black><reg>", nil, nil, nil, "<white><reg>", nil, "<white><breg>", nil, nil},
		{nil, nil, "<black><breg>", nil, "<black><reg>", nil, nil, nil, "<white><reg>", nil, "<white><reg>", nil, nil, nil}
	}
end
vars.resetBoard()

vars.pieceImages = {}  -- tabela onde serão inseridas as imagens das peças
vars.genImages = {}    -- tabela onde serão inseridas as imagens gerais
vars.bgImages = {}     -- tabela onde serão inseridas as imgaens de background (são 16, animado)
vars.borderImages = {} -- tabela onde serão inseridas as imagens do tabuleiro (são 16, animado)

-- configuração do loading
vars.pieceImagesToLoad = { -- imagens de peças que serão inseridas
	"black_reg", "white_reg", "white_breg", "black_breg", 
	"black_crown", "white_crown"
}
vars.genImagesToLoad = {
	"logo"
}

vars.winnerStuff = {
	font = nil,
	text = nil,
	restartFont = nil,
	restartText = nil
}

vars.deffont = nil

vars.loaded = 0
vars.loadsteps = 
	  #vars.pieceImagesToLoad -- imagens das peças
	+ #vars.genImagesToLoad   -- imagem do menu
	+ 4                       -- textos de win
	+ 1                       -- default font
	+ 16                      -- imagens do background animado
	+ 16                      -- imagens do tabuleiro animado

-- modulo
return vars
