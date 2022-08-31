Rules = require("rules")

local AI = {}

---@param cards table Card list to check for playable cards
---@param current_card table Card to check
---@return table playable_cards
function AI.getPlayableCards(cards, current_card)
	local playable_cards = {}
	for i = 1, #cards do
		if Rules.checkNumber(cards[i], current_card) or
		   Rules.checkColor(cards[i], current_card) then
		   table.insert(playable_cards, cards[i])
	   end
	end

	print("PLAYABLE")
	for i = 1, #playable_cards do
		playable_cards[i].print()
	end
	return playable_cards
end

return AI
