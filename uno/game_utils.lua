local GameUtils = {}

---Get index of next player
---
---@param turn table containing game turn info
---@param player_list table list of players
function GameUtils.getNextTurn(turn, player_list)
  local turn_index = turn.index
  if turn.dir then
    if turn_index == #player_list then
      turn_index = 1
    else
      turn_index = turn_index + 1
    end
  else
    if turn_index == 1 then
      turn_index = #player_list
    else
      turn_index = turn_index - 1
    end
  end
  return turn_index
end

---Shuffle _played_pile and insert cards in empty deck
---
---@param played_pile table pile of played cards
---@param deck table deck of cards of game
function GameUtils.refillDeck(played_pile, deck)
  table.shuffle(played_pile)
  for _ = 1, #played_pile do
    table.insert(deck, table.remove(played_pile, 1))
  end
end

return GameUtils
