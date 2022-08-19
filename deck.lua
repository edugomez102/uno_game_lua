Card = require("card")

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

---@param deck table
local function addBlack(deck)
	for _ = 1, 4 do
		table.insert(deck, Card:new({number = "+4"}))
	end
	for _ = 1, 4 do
		table.insert(deck, Card:new({number = "color change"}))
	end
end

-----------------------------------------------------------

local Deck = {} -- namespace

---@param x table
function Deck.shuffle(x)
	math.randomseed(os.time()) -- so that the results are always different
	for i = #x, 2, -1 do
		local j = math.random(i)
		x[i], x[j] = x[j], x[i]
	end
end

function Deck.printDeck(deck)
	for i = 1, #deck do
		deck[i]:print()
	end
end

function Deck.generateDeck()
	local deck = {}

	addColors(deck, 0, "R")
	addColors(deck, 1, "R")
	addColors(deck, 0, "B")
	addColors(deck, 1, "B")
	addColors(deck, 0, "Y")
	addColors(deck, 1, "Y")
	addColors(deck, 0, "G")
	addColors(deck, 1, "G")
	addBlack(deck)

	Deck.shuffle(deck)
	return deck
end

return Deck


