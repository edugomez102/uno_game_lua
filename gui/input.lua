local P     = require("gui.positions")
local Card  = require("uno.card")

local Input = {}
Input.select = nil
Input.max_select = 7

local function checkPosition(x, y, position, fun)
  if x > P[position].x and x < P[position].x + Card.w and
     y > P[position].y and y < P[position].y + Card.h then
    print(position)
    fun()
  end
end

local function selectCards(x, y)
  for i = 1, Input.max_select do
    local xpos = P.card_list.x + (i - 1) * P.card_list.margin
    if x > xpos and x < xpos + Card.w and
       y > P.card_list.y and y < P.card_list.y + Card.h then

      print("hola:", i)
      Input.select = i
    end
  end
end

local function selectSmallCards(x, y)
  local s = 0.75
  local xpos, ypos
  for i = 1, Input.max_select do
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
      Input.select = i
    end
  end
end

-- game state

function Input.update()
  function love.mousepressed(x, y, button, istouch, presses )
    if button == 1 then
      checkPosition(x, y, "exit", function() love.event.quit() end)
      checkPosition(x, y, "deck", function() Input.select = 0 end)

      -- TODO when deal card error, stays big card selection
      if Input.max_select < 20 then selectCards(x, y) else selectSmallCards(x, y) end
      -- selectSmallCards(x, y)
    end
  end
end

function Input.reset() Input.select = nil end

return Input
