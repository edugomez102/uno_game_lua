Rules = require("rules")

local AI = {}

---@param cards table Card list to check for playable cards
---@param current_card table Card to check
---@return table playable_indexes
function AI.getPlayableCards(cards, current_card)
	local playable_indexes = {}
	for i = 1, #cards do
		if Rules.checkNumber(cards[i], current_card) or
		   Rules.checkColor(cards[i], current_card) then
		   -- table.insert(playable_indexes, cards[i])
			table.insert(playable_indexes, i)
	   end
	end

	-- print("PLAYABLE")
	-- for i = 1, #playable_indexes do
	-- 	cards[playable_indexes[i]].print()
	-- end
	return playable_indexes
end

-- TODO improve
---Randomly chooses a card index
---@param cards table Card list to check for playable cards
---@param current_card table Card to play
---@return integer index random index of cards
function AI.chooseCard(cards, current_card)
	local playable_indexes = AI.getPlayableCards(cards, current_card)
	if table.empty(playable_indexes) then
		return 0
	else
		return playable_indexes[math.random(#playable_indexes)]
	end

	-- for i = 1, #playable_indexes do
	-- 	cards[playable_indexes[i]].print()
	-- end
end

-- TODO improve
---Randomly chooses a color index
---@param cards table Card list to check for most color
---@param current_card table Card to play
function AI.chooseColor(cards, current_card)
	-- local colors = {}
	-- for i = 1, #cards do
	-- 	table.insert(colors, cards.color)
	-- end
	return math.random(1, 4)
end


return AI
