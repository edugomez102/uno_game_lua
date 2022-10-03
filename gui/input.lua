local P     = require("gui.positions")
local Card  = require("uno.card")

local Input = {}

local function selectCards(x, y, button)
  for i = 1, 15 do
    local xpos = P.card_list.x + (i - 1) * P.card_list.margin
    if button == 1 and -- right click
       x > xpos and x < xpos + Card.w and
       y > P.card_list.y and y < P.card_list.y + Card.h then

      print("hola:", i)
      return i
    end
  end
end

-- game state

function Input.update()
  function love.mousepressed(x, y, button, istouch, presses )
    selectCards(x, y, button)
  end
end


return Input
