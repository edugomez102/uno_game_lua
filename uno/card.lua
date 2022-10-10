---
---@class Card
---

local Card = {}
Card.w = 72
Card.h = 108

Card.card_colors = { "R", "B", "Y", "G", "K" }

function Card.new(o)
  -------------------------------------------------------------------------------
  -- Public members
  -------------------------------------------------------------------------------
  local self = {
    number = o.number or 0,
    color  = o.color or "K",
    img    = love.graphics.newImage(o.img_path) or nil
  }

  -------------------------------------------------------------------------------
  -- Public functions
  -------------------------------------------------------------------------------

  function self.setImg(path)
    self.img = love.graphics.newImage(path)
  end

  function self.draw(x, y)
    love.graphics.draw(self.img, x, y)
  end

  function self.__tostring()
    return self.color .. ", " .. self.number
  end

  return self
end

Card.any = {
  Card.new{number = "any", color = "R", img_path = ("img/R_.png")},
  Card.new{number = "any", color = "B", img_path = ("img/B_.png")},
  Card.new{number = "any", color = "Y", img_path = ("img/Y_.png")},
  Card.new{number = "any", color = "G", img_path = ("img/G_.png")},
}

function Card.getAnyByColor(color)
  for _, v in pairs(Card.any) do
    if v.color == color then
      return v
    end
  end
end

return Card
