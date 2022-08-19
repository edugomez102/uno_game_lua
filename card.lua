
local Card = {
	color = "K",
	number = 0
}

function Card:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function Card:print()
	print(self.color .. " - " .. self.number)
end

function Card:printToSelect(index)
	print("[".. index .."]: " .. self.color .. " - " .. self.number)
end

return Card
