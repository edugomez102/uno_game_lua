
--- Checks if table contains given key
--- @param t table to ce
--- @param element any to check
function table.has_key(t, element)
	for k in pairs(t) do
		if k == element then
			return true
		end
	end
	return false
end

--- Checks if table contains given value
--- @param t table to ce
--- @param element any to check
function table.has_value(t, element)
	for _, v in pairs(t) do
		if v == element then
			return true
		end
	end
	return false
end

--- Check if table is empty
--- @param t table to check
function table.empty(t)
	if next(table) == nil then return true
	else return false
	end
end

---Shuffles table content
---@param t table to shuffle
function table.shuffle(t)
	math.randomseed(os.time()) -- so that the results are always different
	for i = #t, 2, -1 do
		local j = math.random(i)
		t[i], t[j] = t[j], t[i]
	end
end
