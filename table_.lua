
--- Checks if table contains given key
--- @param table table to ce
--- @param element any to check
function table.has_key(table, element)
	for k in pairs(table) do
		if k == element then
			return true
		end
	end
	return false
end

--- Checks if table contains given value
--- @param table table to ce
--- @param element any to check
function table.has_value(table, element)
	for _, v in pairs(table) do
		if v == element then
			return true
		end
	end
	return false
end

---Shuffles table content
---@param x table
function table.shuffle(x)
	math.randomseed(os.time()) -- so that the results are always different
	for i = #x, 2, -1 do
		local j = math.random(i)
		x[i], x[j] = x[j], x[i]
	end
end
