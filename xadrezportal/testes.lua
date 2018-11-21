local pieces = {
  king = {
    name = "king",
    img = "link_imagem_king",
    regmoves = function (pos_x, pos_y)
        local tabl = {}
        for i = -1, 1 do
          for j = -1, 1 do
            local newpos_x = pos_x + i
            local newpos_y = pos_y + j
            if not (i == 0 and j == 0)
            and not (newpos_y < 1 or newpos_y > 8) then
              if newpos_x <= 0 then newpos_x = 16 - newpos_x end
              table.insert(tabl, {newpos_x, newpos_y})
            end
          end
        end
        return tabl
      end
  },
  queen = {
    name = "queen",
    img = "link_imagem_queen",
    regmoves = function (pos_x, pos_y)
        local tabl = {}
        for i = -15, 15 do
          local newpos_x = pos_x + i
          local newpos_y = pos_y
          if not (i == 0 and j == 0) then
            if newpos_x < 1 then newpos_x = 16 - newpos_x
            elseif newpos_x > 16 then newpos_x = newpos_x - 16 end
            table.insert(tabl, {newpos_x, newpos_y})
          end
        end
        return tabl
      end
  },
  frontpawn = {
    name = "frontpawn",
    img = "link_imagem_pawn",
    regmoves  = { {1, 0} },
    attmoves  = { {1, -1}, {1, 1} },
    specmoves = { {2, 0} }
  },
  backpawn = {
    name = "backpawn",
    img = "link_imagem_pawn",
    regmoves  = { {-1, 0} },
    attmoves  = { {-1, -1}, {-1, 1} },
    specmoves = { {-2, 0} }
  },
  rook = {
    name = "rook",
    img = "link_imagem_rook",
    regmoves = function (pos_x, pos_y)
        local tabl = {}
        for i = -15, 15 do
          local newpos_x = pos_x + i
          local newpos_y = pos_y
          if not (i == 0 and j == 0) then
            if newpos_x < 1 then 
              newpos_x = 16 + newpos_x
            elseif newpos_x > 16 then 
              newpos_x = newpos_x - 16 
            end
            table.insert(tabl, {newpos_x, newpos_y})
          end
        end
        return tabl
      end
  }
}

for i, v in pairs(pieces.rook.regmoves(1, 2)) do
  print(v[1], v[2])
end