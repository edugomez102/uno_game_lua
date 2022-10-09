local Output = { }

---Prints game winner
---
---@param name string player name
function Output.playerWon(name)
	io.write("=====================\n")
	io.write(name .. " HAS WON THE GAME\n")
	io.write("=====================\n")
end

---Prints number of cards left by player when game ends
---
---@param player_list table
function Output.playersCardsLeft(player_list)
  local t = {}
	for i = 1, #player_list do
    t[#t+1] = player_list[i].name .. " had " ..
			player_list[i].getCardNumber() .. " cards left\n"
	end
  return table.concat(t)
end

---Prints played card
---
---@param player table Player
---@param card_to_play table Card
function Output.playedCard(player, card_to_play)
  return player.name .. " played card: " .. card_to_play.__tostring()
end

---Print changed color
---
---@param player table Player
---@param color string Color
function Output.colorChange(player, color)
	return player.name .. " changed color to " .. color, "\n"
end

function Output.playerDraws(player, card)
  if player.isHuman() then
    return player.name .. " draws card " .. card.__tostring()
  else
    return player.name .. " draws a card\n"
  end
end

function Output.turnPass(player)
	return player.name .. " has passed their turn\n"
end

function Output.cantPlay(card_str)
	return "CANT PLAY THAT CARD: " .. card_str
end

function Output.wrongNumberPlayers()
	io.write("Wrong number of players\n")
end

-- function Output.playedCards(played_pile)
-- 	print("------ Played cards")
-- 	for i = 1, #played_pile do
-- 		played_pile[i]:print()
-- 	end
-- end

return Output
