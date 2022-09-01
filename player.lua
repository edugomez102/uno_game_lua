local Input = require("input")
local AI    = require("ai")

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
		-- TODO private ??
		-- if it has drawn in its turn
		has_drawn = false
	}

	-------------------------------------------------------------------------------
	-- Private members
	-------------------------------------------------------------------------------
	local _cards = {}
	local _human = (o.human == nil or o.human == true or false) -- default true

	-------------------------------------------------------------------------------
	-- Public functions
	-------------------------------------------------------------------------------
	function self.isHuman() return _human end

	---Deal cards to player
	---@param deck table
	function self.dealCards(deck)
		-- TODO set to 7
		for _ = 1, 7 do
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

	---@param index integer index of cards
	---@return table Card object
	function self.getCard(index) return _cards[index] end

	-- TODO Delete
	function self.setCard(card) table.insert(_cards, card) end

	---@return number of cards of player
	function self.getCardNumber() return #_cards end

	---@param current_card table Card
	---@return integer index of chosen card
	function self.chooseCard(current_card)
		if _human then
			return Input.readNumber(#_cards)
		else
			return AI.chooseCard(_cards, current_card)
		end
	end

	---@return number index of chosen card
	function self.chooseColor(current_card)
		if _human then
			return Input.readNumber(4)
		else
			return AI.chooseColor(_cards, current_card)
		end
	end

	---TODO use tostirng
	---@param select boolean true to show index of cards
	function self.printCards(select)
		print("== Cards of " .. self.name .. " ==")
		for i = 1, #_cards do
			if select then
				_cards[i].printToSelect(i)
			else
				_cards[i].print()
			end
		end
	end

	return self
end

return Player
