local Deck   = require("uno.deck")
local Card   = require("uno.card")
local Rules  = require("uno.rules")
local Output = require("uno.output")
local Utils  = require("uno.game_utils")
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

  -- TODO delete
  local initial_cards = 7

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

  ---
  ---@param fun function
  ---@param ... any
  local function whenHumanPlayer(fun, ...)
    if currentPlayer().isHuman() then fun(...) end
  end

	---Update _turn.index to the next playing player on the list.
  ---Set has_drawn false for next turn player.
  ---Sleep a bit to see what other players do.
  ---Sort cards of next player.
	---
	local function incrementTurn()
    local player = currentPlayer()
    _turn.index = Utils.getNextTurn(_turn, _player_list)
    player.has_drawn = false
    if not player.isHuman() then love.timer.sleep(0.5) end
    local next_player = currentPlayer()
    if self.sort_cards then next_player.sortCards() end
    whenHumanPlayer(function() Input.max_select = #next_player.getCards() end)
	end

	---Action cards behaviour in a pretty ugly table :)
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
								local next_player =
                  _player_list[Utils.getNextTurn(_turn, _player_list)]
                next_player.dealCards(_deck, 2)
							end,
							---Let the current player choose color and make the next player
							---draw four cards
		["wild draw 4"] = function()
								nextStateColor()
								local next_player =
                  _player_list[Utils.getNextTurn(_turn, _player_list)]
                next_player.dealCards(_deck, 4)
							end,
		["wild"] =  		  nextStateColor
	}

	---Take or pass card. if player has already taken a card then pass
	---
	local function takeOrPass()
		local player = currentPlayer()
		if not player.has_drawn then
      local card = player.takeCard(_deck)
			_text = Output.playerDraws(player, card)
			player.has_drawn = true
      whenHumanPlayer(function() Input.max_select = Input.max_select + 1 end)
		else
			_text = Output.turnPass(player)
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
    local player = currentPlayer()
    if Rules.checkNumberAndColor(card_to_play, _current_card) then
			if _current_card.number ~= "any" then
				table.insert(_played_pile, _current_card)
			end
			_current_card = card_to_play
      player.removeCard(play_move)

      if Rules.checkLastCard(player) then
        _has_ended = true
        print("end game")
        _state = "game_end"
        _text = "game end"

        --TODO final game screen
        -- Output.playerWon(player.name)
        -- Output.playersCardsLeft(_player_list)
        -- love.event.quit()
      end

			if not Rules.checkActionCard(
        _action_cards, _current_card, _turn, _player_list) then
        incrementTurn()
      end

		else
			_text = Output.cantPlay(card_to_play.__tostring())
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

  ---Restarts all default values to start a new game
  ---
  local function restart()
    _deck = Deck.generateDeck()
    _played_pile = {}
    _has_ended = false
    _turn = {
      index = 1,
      dir   = true
    }
    _text = "Game starts!"
    _state = "card"
    for i = 1, #_player_list do
      _player_list[i].reset()
    end
    self.start()
  end

  ---Simple state patrol to manage cards layout when playing card or choosing color
  ---
  ---@function render cards to be rendered in layout
  ---@function input sets Input.max_select to update input
  ---@function play logic of choose state
   local choose_states = {
    card = {
      render = function()
        local player = currentPlayer()
        whenHumanPlayer(Render.selectCards, player.getCards(), _current_card)
      end,
      input = function()
        -- return Input.selectCards
        -- whenHumanPlayer(function() Input.max_select = #currentPlayer().getCards() end)
        if Input.max_select < 15 then
          return Input.selectCards
        else
          return Input.selectSmallCards
        end
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
      end
    end
    },
    color = {
      render = function()
        whenHumanPlayer(Render.selectCards, Card.any, _current_card)
      end,
      input = function()
        -- whenHumanPlayer(function() Input.max_select = #Card.any end)
        return Input.selectCards
      end,
      play = function()
        local color_index = currentPlayer().chooseColor(_current_card)
        if color_index then
          local color = Card.card_colors[color_index]
          _current_card = Card.getAnyByColor(color)
          _text = Output.colorChange(currentPlayer(), color)
          nextStateCard()
          incrementTurn()
        end
      end
    },
    game_end = {
      render = function()
      end,
      input  = function()
      end,
      play   = function()
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
	---Check if number of players is correct
  ---Sort cards of fist playeru
  ---
	function self.start()
		if #_player_list > 10 or #_player_list < 2 then
			Output.wrongNumberPlayers()
			_has_ended = true; love.event.quit()
      return
		end

		for i = 1, #_player_list do
			_player_list[i].dealCards(_deck, initial_cards)
		end
		setInitialCard()
    if self.sort_cards then currentPlayer().sortCards() end
	end

	---Main loop of the game
	---
	function self.play()
    choose_states[_state].play()

		if table.empty(_deck) then Utils.refillDeck(_played_pile, _deck) end
	end

  function self.input()
    Input.update(choose_states[_state].input())

    -- TODO delete
    function love.keypressed(k)
      if k == "n" then incrementTurn() end
      if k == "r" then restart() end
    end
  end

	function self.draw()
    local player = _player_list[_turn.index]
    Render.fixed(_turn, _player_list, _current_card, _text)

    -- if _has_ended then return end
    choose_states[_state].render()
	end

	return self
end

return Game
