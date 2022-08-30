
local Input = {}
--- Reads number input from keyboard
---@return number a read number from keyboard
---@param max_num integer maximun number to read
function Input.readNumber(max_num)
	local a
	repeat
		a = io.read()
		a = tonumber(a)
		if a ~= nil and a > max_num then a = nil end
		if not a then
			print("Incorrect Input!(Try using only numbers)")
		end
	until a
	return a
end

return Input
