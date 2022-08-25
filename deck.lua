Card = require("card")

local Deck = {} -- namespace

-------------------------------------------------------------------------------
-- Private functions
-------------------------------------------------------------------------------

---add cards with colors to deck
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
			c.number = "+2"
		else
			c.number = i
		end
		table.insert(deck, c)
	end
end

--- Adds black cards to deck
---@param deck table
local function addBlack(deck)
	for _ = 1, 4 do
		table.insert(deck, Card.new({number = "+4"}))
	end
	for _ = 1, 4 do
		table.insert(deck, Card.new({number = "color change"}))
	end
end

---@param x table
local function shuffle(x)
	math.randomseed(os.time()) -- so that the results are always different
	for i = #x, 2, -1 do
		local j = math.random(i)
		x[i], x[j] = x[j], x[i]
	end
end

-------------------------------------------------------------------------------
-- Public functions
-------------------------------------------------------------------------------

--- Prints deck
---@param deck table table with list of cards
function Deck.printDeck(deck)
	for i = 1, #deck do
		deck[i]:print()
	end
end

---genereates list of cards, deck with 108 uno cards
---@return table deck deck with 108 uno cards
function Deck.generateDeck()
	local deck = {}

	for i = 1, #Card.card_colors - 1 do
		addColors(deck, 0, Card.card_colors[i])
		addColors(deck, 1, Card.card_colors[i])
	end
	addBlack(deck)
	shuffle(deck)
	return deck
end

return Deck
