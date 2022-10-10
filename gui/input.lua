local P     = require("gui.positions")
local Card  = require("uno.card")

local Input = {}
-- Input.select = nil
-- Input.max_select = 7

---Checks for position in positions module and calls function
---
local function checkPosition(x, y, position, w, h, fun)
  if x > P[position].x and x < P[position].x + w and
     y > P[position].y and y < P[position].y + h then
    -- TODO delete
    print(position)

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

      print("hola:", i)
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

      print("hola:", i)
      return i
    end
  end
end

-- function Input.gameEnd(x, y)
--   local w, h = 50, 50
--   if x > P.endgame.btn1.x and x < P.endgame.btn1.x + w and
--      y > P.endgame.btn1.y and y < P.endgame.btn1.y + h then
--      love.event.quit()
--   end
-- end

function Input.update(input_t)
  function love.mousepressed(x, y, button, istouch, presses )
    if button == 1 then
      input_t.player.selection = input_t.fun(x, y, input_t.max_select)

      -- TODO check 40, 40
      checkPosition(x, y, "restart", 40, 40, function() print("ta") end)
      checkPosition(x, y, "deck", Card.w, Card.h, function()
        input_t.player.selection = 0
      end)
    end
  end
  input_t.player.selection = nil
end

return Input
