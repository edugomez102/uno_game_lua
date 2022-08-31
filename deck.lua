local Card = require("card")

local Deck = {} -- namespace

-------------------------------------------------------------------------------
-- Private functions
-------------------------------------------------------------------------------

---Add cards with colors to deck
---@param deck table
---@param from_number integer 0 or 1
---@param color string with color name
local function addColors(deck, from_number, color)
	for i = from_number, 12 do
		local c = Card:new()
		c.color = color
		if i == 10 then
			c.number = "skip"
		elseif i == 11 then
			c.number = "reverse"
		elseif i == 12 then
			c.number = "draw two"
		else
			c.number = i
		end
		table.insert(deck, c)
	end
end

---Adds black cards to deck
---@param deck table
local function addBlack(deck)
	for _ = 1, 4 do
		table.insert(deck, Card.new({number = "wild draw 4"}))
	end
	for _ = 1, 4 do
		table.insert(deck, Card.new({number = "wild"}))
	end
end

-------------------------------------------------------------------------------
-- Public functions
-------------------------------------------------------------------------------

---Prints deck
---@param deck table table with list of cards
function Deck.printDeck(deck)
	for i = 1, #deck do
		deck[i]:print()
	end
end

---Genereates list of cards, deck with 108 uno cards
---@return table deck deck with 108 uno cards
function Deck.generateDeck()
	local deck = {}

	for i = 1, #Card.card_colors - 1 do
		addColors(deck, 0, Card.card_colors[i])
		addColors(deck, 1, Card.card_colors[i])
	end
	addBlack(deck)
	table.shuffle(deck)
	return deck
end

return Deck
