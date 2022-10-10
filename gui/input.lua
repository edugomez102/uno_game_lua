local P     = require("gui.positions")
local Card  = require("uno.card")

local Input = {}
-- Input.select = nil
-- Input.max_select = 7

---Checks for position in positions module and calls function
---
local function checkPosition(x, y, position, fun)
  if x > position.x and x < position.x + position.w and
     y > position.y and y < position.y + position.h then
    fun()
  end
end

---Select index in cards layout
---
function Input.selectCards(x, y, max_select)
  for i = 1, max_select do
    local xpos = P.card_list.x + (i - 1) * P.card_list.margin
    if x > xpos and x < xpos + Card.w and
       y > P.card_list.y and y < P.card_list.y + Card.h then
      return i
    end
  end
end

---Select index in small cards layout
---
function Input.selectSmallCards(x, y, max_select)
  local s = 0.75
  local xpos, ypos
  for i = 1, max_select do
    if i < 20 then
      xpos = P.card_list_s.x + (i - 1) * P.card_list_s.margin
      ypos = P.card_list_s.y1
    else
      xpos = P.card_list_s.x + (i - 20) * P.card_list_s.margin
      ypos = P.card_list_s.y2
    end

    if x > xpos and x < xpos + Card.w * s and
       y > ypos and y < ypos + Card.h * s then
      return i
    end
  end
end

---Buttons of game end
---
---@param restart function
function Input.gameEnd(x, y, restart)
  checkPosition(x, y, P.endgame.close, function()
    love.event.quit()
  end)
  checkPosition(x, y, P.endgame.restart, function()
    restart()
  end)
end

-------------------------------------------------------------------------------
-- Input system
-------------------------------------------------------------------------------

function Input.update(input_t)
  function love.mousepressed(x, y, button, istouch, presses )
    if button == 1 then
      input_t.player.selection = input_t.fun(x, y, unpack(input_t.args))

      -- TODO check position
      checkPosition(x, y, P.restart, function()
        input_t.restart()
      end)
      checkPosition(x, y, P.deck, function()
        input_t.player.selection = 0
      end)
    end
  end
  input_t.player.selection = nil
end

return Input
