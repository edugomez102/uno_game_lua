local Deck = require("deck")

local Game = {
	player_list = {},
	deck = Deck.generateDeck(),
	played_cards = {},
	has_ended = false
}

function Game:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function Game:addPlayer(p)
	table.insert(self.player_list, p)
end

---deal cards to all players and set initial card
function Game:start()
	-- print("--- Deck ---")
	-- Deck.printDeck(game.deck)

	for i = 1, #self.player_list do
		self.player_list[i]:dealCards(self.deck)
	end
	table.insert(self.played_cards, 1, table.remove(self.deck, 1))
end


--- TODO private ?
local function playCard(current_card, card_to_play)
	if current_card.color == card_to_play.color then
		print("SAME COLOR")
	else
		print("NO COLOR")
	end

	if current_card.number == card_to_play.number then
		print("SAME NUM")
	else
		print("NO NUM")
	end
end

---main loop of the game
function Game:play()

	--index of player_list
	local turn = 1

	print("Current card")
	local current_card = self.played_cards[1]
	current_card:print()

	self.player_list[turn]:printCards(true)

	local play_move = io.read("*number")
	print("played card:")
	local card_to_play = self.player_list[turn].cards[play_move]
	card_to_play:print()

	playCard(current_card, card_to_play)
end

return Game
