local Deck = require("deck")

-------------------------------------------------------------------------------
-- Private static functions
-------------------------------------------------------------------------------

---@return number a read number from keyboard
local function readNumberInput()
	local a
	repeat
		a = io.read()
		a = tonumber(a)
		if not a then
			print("Incorrect Input!(Try using only numbers)")
		end
	until a
	return a
end

local Game = {}

function Game:new()
	self = {}

	-------------------------------------------------------------------------------
	-- Private members
	-------------------------------------------------------------------------------
	local _player_list = {}
	local _deck = Deck.generateDeck()
	local _current_card = {}
	local _played_cards = {}
	local _turn = 1            -- index of player_lis
	local _has_ended = false

	-------------------------------------------------------------------------------
	-- Private functions
	-------------------------------------------------------------------------------

	---checks if number in _current_card and card_to_play are the same
	local function checkNumber(card_to_play)
		if _current_card.number == card_to_play.number or 
			card_to_play.color == "any" then
			return true
		else
			return false
		end
	end

	---checks if color in _current_card and card_to_play are the same
	local function checkColor(card_to_play)
		if _current_card.color == card_to_play.color or
		card_to_play.color == "K" then
			return true
		else
			return false
		end
	end

	local function incrementTurn()
		if _turn >= #_player_list then
			_turn = 1
		else
			_turn = _turn + 1
		end
	end

	--- Checks if card can be playable and icrements player _turn if so
	--- @param card_to_play table Card
	--- @param play_move integer index of card in _player_list
	local function playCard(card_to_play, play_move)

		if checkNumber(card_to_play) or checkColor(card_to_play) then
			table.insert(_played_cards, _current_card)
			_current_card = card_to_play
			_player_list[_turn].removeCard(play_move)
			print("---------------------")
			incrementTurn()
		else
			print("\27[1;31mCANT PLAY THAT CARD \27[0m")
		end
	end

	--- Prints cards of current player
	local function showPlayableCards()
		_player_list[_turn].printCards(true)
		print("[0]: draw card")
		print("---------------------")
	end

	-------------------------------------------------------------------------------
	-- Public functions
	-------------------------------------------------------------------------------

	--- Adds player to _player_list
	function self.addPlayer(p)
		table.insert(_player_list, p)
	end

	--- Deal cards to all players and sets _current_card
	function self.start()
		-- print("--- _deck ---")
		-- _deck.printDeck(_deck)
		-- print("Card number:" .. #_deck)

		for i = 1, #_player_list do
			_player_list[i].dealCards(_deck)
		end
		_current_card = table.remove(_deck, 1)
	end

	local function playerChangeColor()
	end

	--- Main loop of the game
	function self.play()

		io.write("Current card: ")
		_current_card.print()

		showPlayableCards()

		local play_move = readNumberInput()

		if play_move == 0 then
			---TODO only once
			_player_list[_turn].takeCard(_deck)
		else
			local card_to_play = _player_list[_turn].getCard(play_move)
			io.write("played card: ")
			card_to_play.print()

			playCard(card_to_play, play_move)
		end

		-- print("------ Played cards")
		-- for i = 1, #self._played_cards do
		-- 	self._played_cards[i]:print()
		-- end
	end

	return self
end

return Game
