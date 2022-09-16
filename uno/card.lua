local tint = require("modules.tint")

---
---@class Card
---

local Card = {}

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
		img    = o.img
	}

	-------------------------------------------------------------------------------
	-- Public functions
	-------------------------------------------------------------------------------

	---Print card
	---
	---@param index integer print a number before card to show index in card list
	function self.print(index)
		if index then io.write("[".. index .."]: ") end
		io.write(tint(self.color .. " - " .. self.number .. "\n", self.color))
	end

	function self.draw(x, y)
	end
	-- function self.__tostring()
	-- 	return "Card:" .. self.color .. ", " .. self.number
	-- end

	return self
end

return Card
