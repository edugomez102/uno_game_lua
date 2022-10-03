local tint = require("modules.tint")

---
---@class Card
---

local Card = {}
Card.w = 72
Card.h = 108

Card.card_colors = { "R", "B", "Y", "G", "K" }

---Show available card colors to select
---
function Card.showColors()
	io.write("Select a card color\n")
	for i = 1, 4 do
		io.write("[" .. i .. "]: ")
		io.write(tint(Card.card_colors[i] .. "\n", Card.card_colors[i]))
	end
end

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

	---Print card
	---
	---@param index integer print a number before card to show index in card list
	function self.print(index)
		if index then io.write("[".. index .."]: ") end
		io.write(tint(self.color .. " - " .. self.number .. "\n", self.color))
	end

	function self.draw(x, y)
		love.graphics.draw(self.img, x, y)
	end
	-- function self.__tostring()
	-- 	return "Card:" .. self.color .. ", " .. self.number
	-- end

	return self
end

Card.any = {
  Card.new{number = "any", color = "R", img_path = ("img/R_.png")},
  Card.new{number = "any", color = "B", img_path = ("img/B_.png")},
  Card.new{number = "any", color = "Y", img_path = ("img/Y_.png")},
  Card.new{number = "any", color = "G", img_path = ("img/G_.png")},
}

return Card
