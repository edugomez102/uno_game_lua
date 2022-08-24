Player = {
	name = "name",
	cards = {}
}

function Player:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self

	-- TODO empty card list ?
	return o
end

--- Deal cards to player
---@param deck table
function Player:dealCards(deck)
	-- TODO set to 7
	for _ = 1, 3 do
		table.insert(self.cards, table.remove(deck, 1))
	end
end

--- Insert card in cards from deck
---@return table new_card new card reference
function Player:takeCard(deck)
	local new_card = table.remove(deck, 1)
	table.insert(self.cards, new_card)
	return new_card
end

---@param select boolean true to show index of cards
function Player:printCards(select)
	print("Cards of " .. self.name .. ":")
	for i = 1, #self.cards do
		if select then
			self.cards[i]:printToSelect(i)
		else
			self.cards[i]:print()
		end
	end
end

return Player
