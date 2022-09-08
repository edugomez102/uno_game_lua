local Deck  = require("uno.deck")
local Card  = require("uno.card")
local Rules = require("uno.rules")
local tint  = require("modules.tint")

---
---@class Game
---
local Game = {}

function Game.new()
	local self = {}

	-------------------------------------------------------------------------------
	-- Private members
	-------------------------------------------------------------------------------
	local _player_list = {}
	local _deck = Deck.generateDeck()
	local _current_card = {}
	local _played_pile = {}
	local _has_ended = false
	local _turn = {
		index = 1,
		dir   = true
	}

	-------------------------------------------------------------------------------
	-- Private functions
	-------------------------------------------------------------------------------

	---Get index of next player
	---@param turn_index integer curent turn index
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

	---
	---Update _turn.index to the next playing player on the list
	---
	---and set has_drawn false for next turn player
	local function incrementTurn()
		_turn.index = getNextTurn(_turn.index)
		_player_list[_turn.index].has_drawn = false
	end

	---
	---Let player choose next color to play
	---
	local function changeNextCardColor()
		local player = _player_list[_turn.index]
		if player.isHuman() then
			io.write("Select a card color\n")
			Card.showColors()
		end
		local option = player.chooseColor(_current_card)
		_current_card = Card.new({number = "any", color = Card.card_colors[option]})
		io.write(player.name .. " changed color to " .. Card.card_colors[option], "\n")
	end

	---Action cards behaviour
	local _action_cards =
	{
		["skip"]    =   	incrementTurn,
							---Invert turn direction
		["reverse"] =   	function()
								_turn.dir = not _turn.dir
							end,
							---Makes the next player draw two cards
		["draw two"] =  	function()
								local next_player = _player_list[getNextTurn(_turn.index)]
								next_player.takeCard(_deck)
								next_player.takeCard(_deck)
							end,
							---Let the current player choose color and make the next player
							---draw four cards
		["wild draw 4"] =   function()
								changeNextCardColor()
								local next_player = _player_list[getNextTurn(_turn.index)]
								for _ = 1, 4 do
									next_player.takeCard(_deck)
								end
							end,
		["wild"] =  		changeNextCardColor
	}

	---Checks if played card is an action card and calls its function
	---@param card table Card to check
	local function checkActionCard(card)
		if table.has_key(_action_cards, card.number) then
			_action_cards[card.number](_turn, _player_list[_turn.index])
		end
	end

	---Checks if player has no cards so it has won the game
	---@return boolean true if the game ends
	local function checkLastCard()
		local player = _player_list[_turn.index]
		if player.getCardNumber() == 0 then
			_has_ended = true
			io.write("=====================\n")
			io.write(player.name .. " HAS WON THE GAME\n")
			io.write("=====================\n")
			-- TODO improve
			for i = 1, #_player_list do
				io.write( _player_list[i].name .. " had " ..
					_player_list[i].getCardNumber() .. " cards left\n")
			end
			return true
		else
			return false
		end
	end

	---Shuffle _played_pile and insert cards in empty deck
	local function refillDeck()
		table.shuffle(_played_pile)
		for _ = 1, #_played_pile do
			table.insert(_deck, table.remove(_played_pile, 1))
		end
	end

	---Take or pass card. if player has already taken a card
	---then pass
	local function takeOrPass()
		local player = _player_list[_turn.index]
		if not player.has_drawn then
			io.write(player.name .. " draws a card\n")
			player.takeCard(_deck)
			player.has_drawn = true
		else
			io.write(_player_list[_turn.index].name .. " has passed their turn\n")
			incrementTurn()
		end
	end

	---
	---Checks if card can be playable and icrements player _turn.index if so and
	---update _current_card to the played card
	---
	---@param card_to_play table Card
	---@param play_move integer index of card in _player_list
	local function playCard(card_to_play, play_move)
		if Rules.checkNumber(card_to_play, _current_card) or
		   Rules.checkColor(card_to_play, _current_card) then
			if _current_card.number ~= "any" then
				table.insert(_played_pile, _current_card)
			end
			_current_card = card_to_play
			_player_list[_turn.index].removeCard(play_move)
			checkActionCard(_current_card)
			-- TODO move to Game.play ?
			if checkLastCard() then return end
			incrementTurn()
		else
			io.write(tint("CANT PLAY THAT CARD\n", "M"))
		end
	end

	---Prints cards of current player
	local function showPlayableCards()
		_player_list[_turn.index].printCards(true)
		if not _player_list[_turn.index].has_drawn then
			io.write("[0]: draw card\n")
		else
			io.write("[0]: pass\n")
		end
		io.write("---------------------\n")
	end

	---TODO apply action card rules when firsr card is an action card
	---Sets initial card from deck. Cant be an action card
	local function setInitialCard()
		_current_card = table.remove(_deck, 1)
		while table.has_key(_action_cards, _current_card.number) do
			table.insert(_deck, _current_card)
			_current_card = table.remove(_deck, 1)
		end
	end

	-------------------------------------------------------------------------------
	-- Public functions
	-------------------------------------------------------------------------------

	---Adds player to _player_list
	function self.addPlayer(p)
		table.insert(_player_list, p)
	end

	---True if game has ended
	function self.hasEnded() return _has_ended end

	---Deal cards to all players and sets initial card on _current_card
	function self.start()
		for i = 1, #_player_list do
			_player_list[i].dealCards(_deck)
		end
		setInitialCard()
	end

	---Main loop of the game
	function self.play()
		local player = _player_list[_turn.index]

		if player.isHuman() then
			io.write("Current card: \n==> ")
			_current_card.print()
			showPlayableCards()
		end

		local play_move = player.chooseCard(_current_card)

		if play_move == 0 then
			takeOrPass()
		else
			local card_to_play = player.getCard(play_move)
			io.write(player.name .. " played card: ")
			card_to_play.print()

			playCard(card_to_play, play_move)
		end

		if table.empty(_deck) then refillDeck() end

		io.write("---------------------\n")

		-- print("------ Played cards")
		-- for i = 1, #_played_pile do
		-- 	_played_pile[i]:print()
		-- end
	end

	return self
end

return Game
