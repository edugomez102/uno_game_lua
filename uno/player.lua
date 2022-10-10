local AI    = require("uno.ai")

---
---@class Player
---
local Player = {}
function Player.new(o)
  -------------------------------------------------------------------------------
  -- Public members
  -------------------------------------------------------------------------------
  local self = {
    name = o.name or "name",
    has_drawn = false,
    selection = nil
  }

  -------------------------------------------------------------------------------
  -- Private members
  -------------------------------------------------------------------------------

  local _cards = {}
  local _human = (o.human == nil or o.human == true or false) -- default true

  -------------------------------------------------------------------------------
  -- Public functions
  -------------------------------------------------------------------------------

  ---Sorts cards of player
  ---
  function self.sortCards()
    table.sort(_cards, function(c1, c2)
      return c1.color < c2.color
    end)
  end

  function self.reset()
    self.has_drawn = false
    self.selection = nil
    _cards = {}
  end

  function self.isHuman() return _human end

  ---Deal cards to player
  ---@param deck table
  ---@param n integer number of cards to deal
  function self.dealCards(deck, n)
    for _ = 1, n do
      table.insert(_cards, table.remove(deck, 1))
    end
  end

  ---Insert card in cards from deck
  ---@return table new_card new card reference
  function self.takeCard(deck)
    local new_card = table.remove(deck, 1)
    table.insert(_cards, new_card)
    return new_card
  end

  ---Removes card from cards
  ---@param index integer index of cards
  function self.removeCard(index)
    table.remove(_cards, index)
  end

  -- TODO delete
  ---@param index integer index of cards
  ---@return table Card object
  function self.getCard(index) return _cards[index] end

  ---@return table copy of _cards
  function self.getCards() return table.copy(_cards) end

  -- TODO Delete
  function self.setCard(card) table.insert(_cards, card) end

  ---@return number of cards of player
  function self.getCardNumber() return #_cards end

  ---@param current_card table Card
  ---@return integer index of chosen card
  function self.chooseCard(current_card)
    if _human then
      return self.selection
    else
      return AI.chooseCard(_cards, current_card)
    end
  end

  ---@return number index of chosen card
  function self.chooseColor(current_card)
    if _human then
      return self.selection
    else
      return AI.chooseColor(_cards, current_card)
    end
  end

  ---TODO use tostirng
  ---@param select boolean true to show index of cards
  function self.printCards(select)
    io.write("== Cards of " .. self.name .. " ==\n")
    for i = 1, #_cards do

      -- local a = (select and _cards[i].print() or _cards[i].print(i))
      _cards[i].print(select and i or nil)
    end
  end

  return self
end

return Player
