local tint = require("modules.tint")

---
---@class Card
---

local Card = {}

Card.card_colors = { "R", "B", "Y", "G", "K" }

---Show available card colors
function Card.showColors()
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
		color  = o.color or "K"
	}

	-------------------------------------------------------------------------------
	-- Public functions
	-------------------------------------------------------------------------------
	function self.print()
		io.write(tint(self.color .. " - " .. self.number .. "\n", self.color))
	end

	function self.__tostring()
		return "Card:" .. self.color .. ", " .. self.number
	end

	function self.printToSelect(index)
		io.write("[".. index .."]: ")
		io.write(tint( self.color .. " - " .. self.number .. "\n", self.color))
	end

	return self
end

return Card
