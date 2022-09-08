local tint  = require("modules.tint")

local Output = {
	active = true
}

---Prints current card and cards of current player
---
---@param player table Player
---@param current_card table Card
function Output.playerTurn(player, current_card)
	if not Output.active then return end
	io.write("Current card: \n==> ")
	current_card.print()
	player.printCards(true)
	if not player.has_drawn then
		io.write("[0]: draw card\n")
	else
		io.write("[0]: pass\n")
	end
	io.write("---------------------\n")
end

---Prints game winner
---
---@param name string player name
function Output.playerWon(name)
	if not Output.active then return end
	io.write("=====================\n")
	io.write(name .. " HAS WON THE GAME\n")
	io.write("=====================\n")
end

---Prints number of cards left by player when game ends
---
---@param player_list table
function Output.playersCardsLeft(player_list)
	if not Output.active then return end
	for i = 1, #player_list do
		io.write( player_list[i].name .. " had " ..
			player_list[i].getCardNumber() .. " cards left\n")
	end
end

---Prints played card
---
---@param player table Player
---@param card_to_play table Card
function Output.playedCard(player, card_to_play)
	if not Output.active then return end
	io.write(player.name .. " played card: ")
	card_to_play.print()
end

---Print changed color
---
---@param player table Player
---@param color table Color
function Output.colorChange(player, color)
	if not Output.active then return end
	io.write(player.name .. " changed color to " .. color, "\n")
end

function Output.playerDraws(player)
	if not Output.active then return end
	io.write(player.name .. " draws a card\n")
end

function Output.turnPass(player)
	if not Output.active then return end
	io.write(player.name .. " has passed their turn\n")
end

function Output.cantPlay()
	if not Output.active then return end
	io.write(tint("CANT PLAY THAT CARD\n", "M"))
end

function Output.wrongNumberPlayers()
	if not Output.active then return end
	io.write("Wrong number of players\n")
end


---Print separator
---
function Output.separator()
	if not Output.active then return end
	io.write("---------------------\n")
end

-- function Output.playedCards(played_pile)
-- 	print("------ Played cards")
-- 	for i = 1, #played_pile do
-- 		played_pile[i]:print()
-- 	end
-- end

return Output
