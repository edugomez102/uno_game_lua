local P     = require("gui.positions")
local Card  = require('uno.card')
local Rules = require("uno.rules")

local Render = {
  bg_img     = love.graphics.newImage("img/uno_layout.png"),
  arrow_img  = love.graphics.newImage("img/red_arrow.png"),
  player_img = love.graphics.newImage("img/person_1.png"),
  card_back  = love.graphics.newImage("img/cards/back.png"),
  pass_turn  = love.graphics.newImage("img/cards/pass.png"),
  font       = love.graphics.newFont(18),
  font_small = love.graphics.newFont(12)
}

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

---Adds visual hover to hovered area with mouse
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
  local scale, margin = 1, 0
  if not dir then
    scale = -1; margin = self.arrow_img:getWidth()
  end
  love.graphics.draw(self.arrow_img, P.direction.x + margin, P.direction.y, 0, scale, 1)
end

---Renders text with info of the game
---
function Render:Text(str)
  love.graphics.setColor(255, 0, 0)
  love.graphics.print(str, P.gui_text.x, P.gui_text.y)
  resetColors()

end

---Renders players
---
function Render:players(players)
  love.graphics.setFont(self.font_small)
  for i = 1, #players do
    love.graphics.push()
    local s = 0.7
    love.graphics.scale(s, s)
    love.graphics.draw(self.player_img,
      (P.player_list.x + (i - 1) * (self.player_img:getWidth() + P.player_list.margin)) / s,
      (P.player_list.y + 4 ) / s)
    love.graphics.pop()

    love.graphics.setColor(44 / 255, 44 / 255, 45 / 255)
    love.graphics.print(players[i].name,
      P.player_list.x + (i - 1) * (self.player_img:getWidth() + P.player_list.margin),
      P.player_list.y + (self.player_img:getHeight() * s) + 5)
    resetColors()
  end
  love.graphics.setFont(self.font)
end

---Highlights player of current turn
---
function Render:turn(index)
  local w_h = self.player_img:getWidth() - 5
  local xpos = P.player_list.x + (index - 1) *
  (self.player_img:getWidth() + P.player_list.margin) - 12

  love.graphics.setColor(255, 0, 0, 0.9)
  -- love.graphics.setColor(248 / 255, 218 / 255, 39 / 255)
  love.graphics.rectangle( "fill", xpos, P.player_list.y, w_h + 4 , w_h)
  resetColors()
end

---Renders deck to take a card or icon to pass turn
---
function Render:drawOrPass(has_drawn, is_human)
  local s = P.deck.scale
  love.graphics.push()
  love.graphics.scale(s, s)
  if has_drawn and is_human then
    love.graphics.draw(self.pass_turn, P.deck.x / s, P.deck.y / s)
  else
    love.graphics.draw(self.card_back, P.deck.x / s, P.deck.y / s)
  end
  love.graphics.pop()
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
  local s = P.current_card.scale
  love.graphics.scale(s, s)
  card.draw(568 / s, 83 / s)
  love.graphics.pop()
end

local function renderSmallCards(cards, current_card)
  for i = 1, #cards do
    love.graphics.push()
    local s = P.card_list_s.scale
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
    hover(x * s, y * s, Card.w * .75, Card.h * .75,
      getHoverColor(cards[i], current_card))
  end
end

---Renders cards of player in layout
---
---@param cards table
function Render.selectCards(cards, current_card)
  local s = P.card_list.scale
  if #cards < 15 then
    for i = 1, #cards do
      love.graphics.push()
      love.graphics.scale(s, s)
      local y = P.card_list.y / s
      local x = (P.card_list.x + (i - 1) * (P.card_list.margin)) / s

      -- local x, y = P.card_list.x + (i - 1) * (P.card_list.margin), P.card_list.y

      cards[i].draw(x, y)
      love.graphics.pop()
      hover(x * s, y * s, Card.w , Card.h , getHoverColor(cards[i], current_card))
    end
  else
    renderSmallCards(cards, current_card)
  end
end

function Render.gameEnd(cards_left)
  love.graphics.setFont(love.graphics.newFont(15))
  drawRect(P.endgame.bg)

  love.graphics.print(cards_left, P.endgame.text.x, P.endgame.text.y)
end

-------------------------------------------------------------------------------
-- Render system
-------------------------------------------------------------------------------

---@param render_t table containing render function and its args
---
function Render.update(render_t)
  if render_t then
    render_t.fun(unpack(render_t.args))
  end
end

---Elements to be renderd always
---
---@param turn table containing game turn info
---@param player_list table list of players
---@param current_card table
---@param text string rendering game info
function Render.fixed(turn, player_list, current_card, text)
  local player = player_list[turn.index]
  Render:background()
  Render:playingDirection(turn.dir)
  Render:turn(turn.index)
  Render:players(player_list)
  Render:drawOrPass(player.has_drawn, player.isHuman())
  Render:Text(text)

  Render.currentCard(current_card)
  hover(P.restart.x , P.restart.y, P.restart.w, P.restart.h, getHoverColor())
end

return Render
