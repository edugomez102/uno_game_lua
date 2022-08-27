local Card = {}

-- static member
Card.card_colors = { "R", "B", "Y", "G", "K" }

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
		print(self.color .. " - " .. self.number)
	end

	function self.__tostring()
		return "Card:" .. self.color .. ", " .. self.number
	end

	function self.printToSelect(index)
		print("[".. index .."]: " .. self.color .. " - " .. self.number)
	end

	return self
end

return Card
