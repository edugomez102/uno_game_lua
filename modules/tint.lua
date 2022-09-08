local colors = {
	R = "\27[1;31m",
	B = "\27[1;34m",
	Y = "\27[1;33m",
	G = "\27[1;32m",
	K = "\27[1;30m",
	M = "\27[1;35m",
	reset = "\27[0m"
}

---Retunrs string with terminal escape colors
---@param str string
---@param color string terminal color
local function tint(str, color)
	return colors[color] .. str .. colors.reset
end

return tint

