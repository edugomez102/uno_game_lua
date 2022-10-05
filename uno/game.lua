local Deck  = require("uno.deck")
local Card  = require("uno.card")
local Rules = require("uno.rules")
local Output = require("uno.output")
local Render = require("gui.render")
local Input  = require("gui.input")

---
---@class Game
---
local Game = {}

function Game.new(o)
  local self = {
    sort_cards = o.sort_cards or false
  }

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
  -- text to render
  local _text = "Game starts!"
  local _state = "card"

	-------------------------------------------------------------------------------
	-- Private functions
	-------------------------------------------------------------------------------

  ---Get current turn player
  ---
  ---@return table player
  local function currentPlayer() return _player_list[_turn.index] end

  ---States

  ---Let player choose next color to play
  local function nextStateCard()  _state = "card"  end

  ---Let player choose a card to play
  local function nextStateColor() _state = "color" end

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
    local player = currentPlayer()
    if self.sort_cards then player.sortCards() end
		_turn.index = getNextTurn(_turn.index)
    player.has_drawn = false

    -- TODO check
    love.timer.sleep(0.5)
	end

	---Action cards behaviour
	---
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
		["wild draw 4"] = function()
								nextStateColor()
								local next_player = _player_list[getNextTurn(_turn.index)]
								for _ = 1, 4 do
									next_player.takeCard(_deck)
								end
							end,
		["wild"] =  		  nextStateColor
	}

	---Checks if played card is an action card and calls its function
	---
	---@param card table Card to check
  ---@return boolean true if action card requires player to change color
	local function checkActionCard(card)
		if table.has_key(_action_cards, card.number) then
			_action_cards[card.number](_turn, _player_list[_turn.index])
      if string.find(card.number, "wild") then return true end
		end
    return false
	end

	---Shuffle _played_pile and insert cards in empty deck
	---
	local function refillDeck()
		table.shuffle(_played_pile)
		for _ = 1, #_played_pile do
			table.insert(_deck, table.remove(_played_pile, 1))
		end
	end

	---Take or pass card. if player has already taken a card then pass
	---
	local function takeOrPass()
		local player = _player_list[_turn.index] -- Player
		if not player.has_drawn then
      local card = player.takeCard(_deck)
			Output.playerDraws(player, card)
			player.has_drawn = true
		else
			Output.turnPass(player)
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

			if not checkActionCard(_current_card) then
        incrementTurn()
      end

		else
			Output.cantPlay()
		end
	end

	---TODO apply action card rules when firsr card is an action card
	---Sets initial card from deck. Cant be an action card
	---
	local function setInitialCard()
		_current_card = table.remove(_deck, 1)
		while table.has_key(_action_cards, _current_card.number) do
			table.insert(_deck, _current_card)
			_current_card = table.remove(_deck, 1)
		end
	end

  ---Simple state platrol to manage cards layout when playing card or choosing color
  ---
  local choose_states = {
    card = {
      render = function() return currentPlayer().getCards() end,
      input = function()
        Input.max_select = currentPlayer().getCardNumber()
      end,
      play = function()
        local player = currentPlayer()
        local play_move = player.chooseCard(_current_card)
        if play_move then
          if play_move == 0 then
            takeOrPass()
          else
            local card_to_play = player.getCard(play_move)
            _text = Output.playedCard(player, card_to_play)
            playCard(card_to_play, play_move)
          end
          Input.reset()
      end
    end
    },
    color = {
      render = function() return Card.any end,
      input = function()
        Input.max_select = #Card.any
      end,
      play = function()
        local color_index = currentPlayer().chooseColor(_current_card)
        if color_index then
          local color = Card.card_colors[color_index]
          _current_card = Card.getAnyByColor(color)
          -- Output.colorChange(player, color)
          nextStateCard()
          incrementTurn()
        end
        Input.reset()
      end
    }
  }

	-------------------------------------------------------------------------------
	-- Public functions
	-------------------------------------------------------------------------------

	---Adds player to _player_list
	---
	function self.addPlayer(p)
		table.insert(_player_list, p)
	end

	---True if game has ended
	---
	function self.hasEnded() return _has_ended end

	---Deal cards to all players and sets initial card on _current_card
	---
	function self.start()
		if #_player_list > 10 or #_player_list < 2 then
			Output.wrongNumberPlayers()
			_has_ended = true
		end
		for i = 1, #_player_list do
			_player_list[i].dealCards(_deck)
		end
		setInitialCard()
    if self.sort_cards then currentPlayer().sortCards() end
		-- for i = 1, #_deck do
		-- 	io.write(_deck[i].img .. "    ")
		-- 	_deck[i].print()
		-- end
	end

	---Main loop of the game
	---
	function self.play()
    local player = currentPlayer()

    -- Bug when sortCards called inside loop
		-- if player.isHuman() then
    --   if self.sort_cards then player.sortCards() end
		-- 	-- Output.playerTurn(player, _current_card)
		-- end

    choose_states[_state].play()
		if table.empty(_deck) then refillDeck() end
    if Rules.checkLastCard(currentPlayer()) then
      _has_ended = true
      --TODO final game screen
      Output.playerWon(player.name)
      Output.playersCardsLeft(_player_list)
      love.event.quit()
    end
	end

  function self.input()
    choose_states[_state].input()
    Input.update()

    -- TODO delete
    function love.keypressed(k)
      if k == "n" then
        incrementTurn()
      end
    end

  end

	function self.draw()
    local player = _player_list[_turn.index]

    Render:background()
    Render:playingDirection(_turn.dir)
    Render:turn(_turn.index)
    Render:players(_player_list)

    Render.currentCard(_current_card)

    if player.isHuman() then
      Render.selectCards(choose_states[_state].render())
    end

    -- Render.selectCards(player.getCards())
    -- Render.selectCards(_deck)
    -- Render.selectCards(Card.any)

    Render:Text(_text)

	end

	return self
end

return Game
