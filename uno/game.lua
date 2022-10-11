require("modules.table_")

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
  local _text = "Game starts!" -- text to render
  local _state = "card"

  -------------------------------------------------------------------------------
  -- Private functions
  -------------------------------------------------------------------------------

  ---Get current turn player
  ---
  ---@return table player
  local function currentPlayer() return _player_list[_turn.index] end

  ---Let player choose next color to play
  local function nextStateCard()  _state = "card"  end

  ---Let player choose a card to play
  local function nextStateColor() _state = "color" end
  local function nextStateEnd()   _state = "game_end" end

  ---Update _turn.index to the next playing player on the list.
  ---Set has_drawn false for next turn player.
  ---Sort cards of next player.
  ---
  local function incrementTurn()
    local player = currentPlayer()
    _turn.index = Utils.getNextTurn(_turn, _player_list)
    player.has_drawn = false
    local next_player = currentPlayer()
    if self.sort_cards then next_player.sortCards() end
  end

  ---Action cards behaviour in a pretty ugly table :)
  ---
  local _action_cards = {
    ["skip"] = incrementTurn,
    ---Invert turn direction
    ["reverse"] = function()
      _turn.dir = not _turn.dir
    end,
    ---Makes the next player draw two cards
    ["draw two"] = function()
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
    ["wild"] = nextStateColor
  }

  ---Draw or pass card. if player has already taken a card then pass
  ---
  local function drawOrPass()
    local player = currentPlayer()
    if not player.has_drawn then
      local card = player.takeCard(_deck)
      _text = Output.playerDraws(player, card)
      player.has_drawn = true
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
        nextStateEnd()
        _text = player.name .. " has won the game."
      end

      if _state == "card" and not Rules.checkActionCard(_action_cards,
        _current_card, _turn, _player_list) then
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
    nextStateCard()
    for i = 1, #_player_list do
      _player_list[i].reset()
    end
    self.start()
  end

  ---Simple state patrol to manage cards layout when playing card or choosing color
  ---
  ---@function render returns function to use by render system
  ---@function input  returns function to use by input system
  ---@function play logic of choose state
  local choose_states = {
    card = {
      render = function()
        local player = currentPlayer()
        if player.isHuman() then
          return {
            fun = Render.selectCards,
            args = {
              player.getCards(),
              _current_card
            }
          }
        end
      end,
      input = function()
        local t = {
          player = currentPlayer(),
          restart = restart,
          args = {
            #currentPlayer().getCards()
          }
        }
        if t.args[1] < 15 then t.fun = Input.selectCards
        else t.fun = Input.selectSmallCards end
        return t
      end,
      play = function()
        local player = currentPlayer()
        local play_move = player.chooseCard(_current_card)
        if play_move then
          if play_move == 0 then
            drawOrPass()
          else
            local card_to_play = player.getCards()[play_move]
            _text = Output.playedCard(player, card_to_play)
            playCard(card_to_play, play_move)
          end
        end
      end
    },
    color = {
      render = function()
        local player = currentPlayer()
        if player.isHuman() then
          return {
            fun = Render.selectCards,
            args = {
              Card.any,
              _current_card
            }
          }
        end
      end,
      input = function()
        return {
          fun = Input.selectCards,
          args = { #Card.any },
          player = currentPlayer(),
          restart = restart
        }
      end,
      play = function()
        local color_index = currentPlayer().chooseColor(_current_card)
        if color_index and color_index > 0 then
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
        return {
          fun = Render.gameEnd,
          args = {
            Output.playersCardsLeft(_player_list)
          }
        }
      end,
      input  = function()
        return {
          fun = function () end,
          player = currentPlayer(),
          restart = restart
        }
      end,
      play   = function() end
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
      _player_list[i].dealCards(_deck, 7)
    end
    setInitialCard()
    if self.sort_cards then currentPlayer().sortCards() end
  end

  ---Main loop of the game
  ---
  function self.play()
    -- TODO use coroutine
    if not currentPlayer().isHuman() then love.timer.sleep(1) end
    choose_states[_state].play()
    if table.empty(_deck) then Utils.refillDeck(_played_pile, _deck) end
  end

  function self.input()
    Input.update(choose_states[_state].input())
  end

  function self.draw()
    Render.fixed(_turn, _player_list, _current_card, _text)
    Render.update(choose_states[_state].render())
  end

  return self
end

return Game
