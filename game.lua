require("table_has")

local Deck = require("deck")

-------------------------------------------------------------------------------
-- Private static functions
-------------------------------------------------------------------------------

--- Reads number input from keyboard
---@return number a read number from keyboard
---@param max_num integer maximun number to read
local function readNumberInput(max_num)
	local a
	repeat
		a = io.read()
		a = tonumber(a)
		if a ~= nil and a > max_num then a = nil end
		if not a then
			print("Incorrect Input!(Try using only numbers)")
		end
	until a
	return a
end

local Game = {}

function Game.new()
	local self = {}

	-------------------------------------------------------------------------------
	-- Private members
	-------------------------------------------------------------------------------
	local _player_list = {}
	local _deck = Deck.generateDeck()
	local _current_card = {}
	local _played_cards = {}
	local _turn = {
		index = 1,
		dir   = true
	}
	local _has_ended = false

	-------------------------------------------------------------------------------
	-- Private functions
	-------------------------------------------------------------------------------

	--- Get index of next player
	--- @param turn_index integer curent turn index
	local function getNextTurn(turn_index)
		if _turn.dir then
			if turn_index == #_player_list then
				turn_index = 1
			else
				turn_index = turn_index + 1
			end
		else
			if turn_index == 1 then
				turn_index = #_player_list
			else
				turn_index = turn_index - 1
			end
		end
		return turn_index
	end

	--- Update _turn.index to the next playing player on the list
	local function incrementTurn()
		_turn.index = getNextTurn(_turn.index)
		-- set has_drawn false for next turn player
		_player_list[_turn.index].has_drawn = false
	end

	---Let player choose next color to play
	local function changeNextCardColor()
		Card.showColors()
		local option = readNumberInput(4)
		_current_card = Card.new({number = "any", color = Card.card_colors[option]})

	end

	--- Action cards behaviour
	local _action_cards = {
		["skip"] = incrementTurn,
		["reverse"] =
		function()
			_turn.dir = not _turn.dir
		end,
		["draw two"] =
		---  Makes the next player draw two cards
		function()
			local next_player = _player_list[getNextTurn(_turn.index)]
			next_player.takeCard(_deck)
			next_player.takeCard(_deck)
		end,
		["wild draw 4"] =
		---Let the current player choose color and make the next player 
		---draw four cards
		function()
			changeNextCardColor()
			local next_player = _player_list[getNextTurn(_turn.index)]
			for _ = 1, 4 do
				next_player.takeCard(_deck)
			end
		end,
		["wild"] = changeNextCardColor
	}

	--- Checks if number in _current_card and card_to_play are the same
	--- @param card_to_play table Card
	local function checkNumber(card_to_play)
		if _current_card.number == card_to_play.number or
			card_to_play.number == "any" then
			return true
		else
			return false
		end
	end

	--- Checks if color in _current_card and card_to_play are the same
	--- @param card_to_play table Card
	local function checkColor(card_to_play)
		if _current_card.color == card_to_play.color or
		card_to_play.color == "K" then
			return true
		else
			return false
		end
	end

	--- Checks if played card makes changes in the game
	--- @param card table Card to check
	local function checkActionCard(card)
		if table.has_key(_action_cards, card.number) then
			print("ACTION CARD")
			_action_cards[card.number](_turn, _player_list[_turn.index])
		end
	end

	--- Take or pass card. if player has already taken a card
	--- then pass
	local function takeOrPass(player)
		---TODO only once
		if not player.has_drawn then
			player.takeCard(_deck)
			player.has_drawn = true
		else
			incrementTurn()
		end
	end


	--- Checks if card can be playable and icrements player _turn.index if so
	--- @param card_to_play table Card
	--- @param play_move integer index of card in _player_list
	local function playCard(card_to_play, play_move)
		if checkNumber(card_to_play) or checkColor(card_to_play) then
			if _current_card.number ~= "any" then
				table.insert(_played_cards, _current_card)
			end
			_current_card = card_to_play
			_player_list[_turn.index].removeCard(play_move)
			checkActionCard(_current_card)
			print("---------------------")
			incrementTurn()
		else
			print("\27[1;31mCANT PLAY THAT CARD \27[0m")
		end
	end

	--- Prints cards of current player
	local function showPlayableCards()
		_player_list[_turn.index].printCards(true)
		if not _player_list[_turn.index].has_drawn then
			print("[0]: draw card")
		else
			print("[0]: pass")
		end
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
		-- _current_card = table.remove(_deck, 1)
		-- _current_carw = Card.new({number = "1", color = "R"})
		_current_card = Card.new({number = "reverse", color = "R"})
	end

	--- Main loop of the game
	function self.play()

		io.write("Current card: ")
		_current_card.print()

		local player = _player_list[_turn.index]
		showPlayableCards()

		local play_move = readNumberInput(player.getCardNumber())

		if play_move == 0 then
			takeOrPass(player)
		else
			local card_to_play = player.getCard(play_move)
			io.write(player.name .. " played card: ")
			card_to_play.print()

			playCard(card_to_play, play_move)
		end

		-- print("------ Played cards")
		-- for i = 1, #_played_cards do
		-- 	_played_cards[i]:print()
		-- end
	end

	return self
end

return Game
