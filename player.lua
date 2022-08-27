--- Player class
---

local Player = {}
function Player.new(p_name)
	-------------------------------------------------------------------------------
	-- Public members
	-------------------------------------------------------------------------------
	local self = {
		name = p_name or "name"
	}

	-------------------------------------------------------------------------------
	-- Private members
	-------------------------------------------------------------------------------
	local _cards = {}

	-------------------------------------------------------------------------------
	-- Public functions
	-------------------------------------------------------------------------------

	--- Deal cards to player
	--- @param deck table
	function self.dealCards(deck)
		-- TODO set to 7
		for _ = 1, 3 do
			table.insert(_cards, table.remove(deck, 1))
		end
	end

	--- Insert card in cards from deck
	--- @return table new_card new card reference
	function self.takeCard(deck)
		local new_card = table.remove(deck, 1)
		table.insert(_cards, new_card)
		return new_card
	end

	--- Removes card from cards
	--- @param index integer index of cards
	function self.removeCard(index)
		table.remove(_cards, index)
	end

	--- @param index integer index of cards
	--- @return table Card object
	function self.getCard(index)
		return _cards[index]
	end

	--- TODO use tostirng
	--- @param select boolean true to show index of cards
	function self.printCards(select)
		print("_cards of " .. self.name .. ":")
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
