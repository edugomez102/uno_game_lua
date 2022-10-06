local P     = require("gui.positions")
local Card  = require('uno.card')

local Render = {
  bg_img     = love.graphics.newImage("img/uno_layout.png"),
  arrow_img  = love.graphics.newImage("img/arrow.png"),
  player_img = love.graphics.newImage("img/person_1.png"),
  card_back  = love.graphics.newImage("img/back.png"),
  pass_turn  = love.graphics.newImage("img/pass.png"),
  font       = love.graphics.newFont(20)
}

local function resetColors()
  love.graphics.setColor(255, 255, 255)
end

-- adds visual hover to hovered area with mouse
local function hover(xpos, ypos, w, h)
  local mx, my = love.mouse.getPosition()
  if mx > xpos and mx < xpos + w and
     my > ypos and my < ypos + h then
     love.graphics.setColor(0, 0, 0, 0.25)
     love.graphics.rectangle("fill", xpos, ypos, w, h)
     resetColors()
   end
end

-------------------------------------------------------------------------------
-- Public functions
-------------------------------------------------------------------------------

---Renders background
---
function Render:background()
  love.graphics.push()
  local s = 0.24
  love.graphics.scale(s, s)
  love.graphics.draw(self.bg_img, 0, 0)
  love.graphics.pop()
end

---Renders arrow. flips arrow if direction is false
---
function Render:playingDirection(dir)
  -- TODO invertir
  local scale, margin = 1, 0
  if not dir then
    scale = -1; margin = self.arrow_img:getWidth()
  end
  love.graphics.draw(self.arrow_img, P.direction.x + margin, P.direction.y, 0, scale, 1)
end


---Renders text with info of the game
---
function Render:Text(str)
  -- TODO change
  love.graphics.setColor(255, 0, 0)
  love.graphics.setFont(Render.font)
  love.graphics.print(str, P.gui_text.x, P.gui_text.y)
  resetColors()

end

---Renders players
---
function Render:players(players)
  for i = 1, #players do
    love.graphics.draw(self.player_img,
      P.player_list.x + (i - 1) * (self.player_img:getWidth() + P.player_list.margin),
      P.player_list.y)

    -- TODO place text in top of img
    love.graphics.print(players[i].name,
      P.player_list.x + (i - 1) * (self.player_img:getWidth() + P.player_list.margin),
      P.player_list.y)
  end
end

---Renders arrow with game direction
---
function Render:turn(index)
  local w_h = self.player_img:getWidth()
  local xpos = P.player_list.x + (index - 1) *
  (self.player_img:getWidth() + P.player_list.margin)

  love.graphics.setColor(255, 0, 0)
  love.graphics.rectangle( "fill", xpos, P.player_list.y, w_h, w_h)
  resetColors()
end

---Renders deck to take a card or icon to pass turn
---
function Render:deckOrPass(has_drawn, is_human)
  if not has_drawn then
    love.graphics.draw(self.card_back, P.deck.x, P.deck.y)
  else
    love.graphics.draw(self.pass_turn, P.deck.x, P.deck.y)
  end
  if is_human then
    hover(P.deck.x, P.deck.y, Card.w, Card.h)
  end
end

-------------------------------------------------------------------------------
-- Static functions
-------------------------------------------------------------------------------

---Renders card to be played
---
---@param card table
function Render.currentCard(card)
  love.graphics.push()
  local s = 2
  love.graphics.scale(s, s)
  card.draw(568 / s, 83 / s)
  love.graphics.pop()
end

local function renderSmallCards(cards)
  for i = 1, #cards do
    love.graphics.push()
    local s = 0.75
    local x, y
    if i < 20 then
      y = P.card_list_s.y1 / s
      x = (P.card_list_s.x + (i - 1) * (P.card_list_s.margin)) / s
    else
      y = P.card_list_s.y2 / s
      x = (P.card_list_s.x + (i - 20) * (P.card_list_s.margin)) / s
    end

    love.graphics.scale(s, s)
    cards[i].draw(x , y)

    --  TODO fix
    -- hover(x / s , y / s, Card.w , Card.h )
    love.graphics.pop()
  end
end

---Renders cards of player in layout
---
---@param cards table
function Render.selectCards(cards)
  if #cards < 15 then
    for i = 1, #cards do
      local x, y = P.card_list.x + (i - 1) * (P.card_list.margin), P.card_list.y
      cards[i].draw(x, y)
      hover(x, y, Card.w, Card.h )
    end
  else
    renderSmallCards(cards)
  end
end

return Render
