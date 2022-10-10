local P     = require("gui.positions")
local Card  = require('uno.card')
local Rules = require("uno.rules")

local Render = {
  bg_img     = love.graphics.newImage("img/uno_layout2.png"),
  arrow_img  = love.graphics.newImage("img/red_arrow.png"),
  player_img = love.graphics.newImage("img/person_1.png"),
  card_back  = love.graphics.newImage("img/back.png"),
  pass_turn  = love.graphics.newImage("img/pass.png"),
  font       = love.graphics.newFont(20)
}

-- TODO fix
love.graphics.setFont(Render.font)

local function resetColors()
  love.graphics.setColor(255, 255, 255)
end

local function drawRect(pos)
  love.graphics.setColor(pos.color)
  love.graphics.rectangle("fill", pos.x, pos.y, pos.w, pos.h)
  resetColors()
end

local function getHoverColor(card, current_card)
  if card and current_card then
    if Rules.checkNumberAndColor(card, current_card) then
      return {0, 255, 0, 0.3}
    else
      return {255, 0, 0, 0.3}
    end
  else
    return {0, 0, 0, 0.3}
  end
end

-- adds visual hover to hovered area with mouse
local function hover(xpos, ypos, w, h, colors)
  local mx, my = love.mouse.getPosition()
  if mx > xpos and mx < xpos + w and
    my > ypos and my < ypos + h then
    love.graphics.setColor(colors)
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

---Highlights player of current turn
---
function Render:turn(index)
  local w_h = self.player_img:getWidth()
  local xpos = P.player_list.x + (index - 1) *
  (self.player_img:getWidth() + P.player_list.margin)

  love.graphics.setColor(255, 0, 0)
  -- love.graphics.setColor(248, 218, 39)
  love.graphics.rectangle( "fill", xpos, P.player_list.y, w_h, w_h)
  resetColors()
end

---Renders deck to take a card or icon to pass turn
---
function Render:deckOrPass(has_drawn, is_human)
  if has_drawn and is_human then
    love.graphics.draw(self.pass_turn, P.deck.x, P.deck.y)
  else
    love.graphics.draw(self.card_back, P.deck.x, P.deck.y)
  end
  if is_human then
    hover(P.deck.x, P.deck.y, Card.w, Card.h, getHoverColor())
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

local function renderSmallCards(cards, current_card)
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
    love.graphics.pop()
    hover(x * s, y * s, Card.w * s, Card.h * s,
    getHoverColor(cards[i], current_card))
  end
end

---Renders cards of player in layout
---
---@param cards table
function Render.selectCards(cards, current_card)
  if #cards < 15 then
    for i = 1, #cards do
      local x, y = P.card_list.x + (i - 1) * (P.card_list.margin), P.card_list.y
      cards[i].draw(x, y)
      hover(x, y, Card.w, Card.h, getHoverColor(cards[i], current_card))
    end
  else
    renderSmallCards(cards, current_card)
  end
end

function Render.gameEnd(cards_left)
  drawRect(P.endgame.bg)
  drawRect(P.endgame.close)
  drawRect(P.endgame.restart)

  love.graphics.print(cards_left, P.endgame.text.x, P.endgame.text.y)
  -- love.graphics.rectangle("fill", P.endgame.text., 0, 100, 100)

end

---Elements to be renderd always
---
---@param turn table containing game turn info
---@param player_list table list of players
---@param current_card table
---@param text string rendering game info
function Render.fixed(turn, player_list, current_card, text)
  -- TODO make private funcs
  local player = player_list[turn.index]
  Render:background()
  Render:playingDirection(turn.dir)
  Render:turn(turn.index)
  Render:players(player_list)
  Render:deckOrPass(player.has_drawn, player.isHuman())
  Render:Text(text)

  Render.currentCard(current_card)
end

function Render.update(render_t)
  if render_t then
    render_t.fun(unpack(render_t.args))
  end
end

return Render
