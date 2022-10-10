local Card = require("uno.card")

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
    local number
    local img = "img/" .. color .. "_"
    if i == 10 then
      number = "skip"
      img = img .. "skip"
    elseif i == 11 then
      number = "reverse"
      img = img .. "reverse"
    elseif i == 12 then
      number = "draw two"
      img = img .. "+2"
    else
      number = i
      img = img .. i
    end
    img = img .. ".png"
    table.insert(deck, Card.new{number = number, color = color, img_path = img})
  end
end

---Adds black cards to deck
---@param deck table
local function addBlack(deck)
  for _ = 1, 4 do
    table.insert(deck, Card.new({
      number   = "wild draw 4",
      img_path = "img/K_+4.png",
    }))
  end
  for _ = 1, 4 do
    table.insert(deck, Card.new({
      number = "wild",
      img_path = "img/K_wild.png",
    }))
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
