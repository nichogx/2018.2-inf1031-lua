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

vars.cfgs = {
	"esc - Sair",
	"R - Recomeçar",
	"H - Habilitar/desabilitar modo help"
}

-- coloca no estado inicial
vars.gameState = "loading"

vars.board = {} -- tabuleiro (indexado ao contrário do love: primeiro linha, depois coluna)
function vars.resetBoard()
	vars.board = { -- tabuleiro (indexado ao contrário do love: primeiro linha, depois coluna)
		{nil, nil, "<black><bpawn>", "<black><rook>",   "<black><fpawn>", nil, nil, nil, nil, "<white><fpawn>", "<white><rook>",   "<white><bpawn>", nil, nil},
		{nil, nil, "<black><bpawn>", "<black><knight>", "<black><fpawn>", nil, nil, nil, nil, "<white><fpawn>", "<white><knight>", "<white><bpawn>", nil, nil},
		{nil, nil, "<black><bpawn>", "<black><bishop>", "<black><fpawn>", nil, nil, nil, nil, "<white><fpawn>", "<white><bishop>", "<white><bpawn>", nil, nil},
		{nil, nil, "<black><bpawn>", "<black><king>",   "<black><fpawn>", nil, nil, nil, nil, "<white><fpawn>", "<white><king>",   "<white><bpawn>", nil, nil},
		{nil, nil, "<black><bpawn>", "<black><queen>",  "<black><fpawn>", nil, nil, nil, nil, "<white><fpawn>", "<white><queen>",  "<white><bpawn>", nil, nil},
		{nil, nil, "<black><bpawn>", "<black><bishop>", "<black><fpawn>", nil, nil, nil, nil, "<white><fpawn>", "<white><bishop>", "<white><bpawn>", nil, nil},
		{nil, nil, "<black><bpawn>", "<black><knight>", "<black><fpawn>", nil, nil, nil, nil, "<white><fpawn>", "<white><knight>", "<white><bpawn>", nil, nil},
		{nil, nil, "<black><bpawn>", "<black><rook>",   "<black><fpawn>", nil, nil, nil, nil, "<white><fpawn>", "<white><rook>",   "<white><bpawn>", nil, nil}
	}
end
vars.resetBoard()

vars.pieceImages = {} -- tabela onde serão inseridas as imagens das peças
vars.genImages = {}   -- tabela onde serão inseridas as imagens gerais

-- configuração do loading
vars.pieceImagesToLoad = { -- imagens de peças que serão inseridas
	"white_fpawn", "white_bpawn", "white_rook", "white_knight", "white_bishop", 
	"white_king", "white_queen", "black_fpawn", "black_bpawn", "black_rook", 
	"black_knight", "black_bishop", "black_king", "black_queen"
}
vars.genImagesToLoad = {
	"logo"
}

vars.loaded = 0
vars.loadsteps = 
	  #vars.pieceImagesToLoad -- imagens das peças
	+ #vars.genImagesToLoad   -- imagem do menu

-- modulo
return vars
