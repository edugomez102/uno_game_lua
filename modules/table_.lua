---
---Extended table namespace
---

---Checks if table contains given key
---@param t table to ce
---@param element any to check
function table.has_key(t, element)
	for k in pairs(t) do
		if k == element then
			return true
		end
	end
	return false
end

---Checks if table contains given value
---@param t table to ce
---@param element any to check
function table.has_value(t, element)
	for _, v in pairs(t) do
		if v == element then
			return true
		end
	end
	return false
end

---Counts number of elements in a table
---@param t table
---@param element any to check
function table.count_value(t, element)
	local count = 0
	for _, v in pairs(t) do
		if v == element then
			count = count + 1
		end
	end
	return count
end

---Check if table is empty
---@param t table to check
function table.empty(t)
	if next(t) == nil then return true
	else return false
	end
end

---Shuffles table content
---using math.randomseed(os.time()) so results are always different
---@param t table to shuffle
function table.shuffle(t)
	math.randomseed(os.time())
	for i = #t, 2, -1 do
		local j = math.random(i)
		t[i], t[j] = t[j], t[i]
	end
end
