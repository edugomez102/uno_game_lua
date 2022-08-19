

local t1 = { "a", "b", "c" }
local t2 = {"x", "y", "z"}

table.insert(t1, 1, "test")
table.insert(t1, 1, "da")

-- local que = table.move(t1, 1, 3}, 4, t2)

for i = 1, #t1 do
	print(t1[i])
end

-- local values = {1,45,1,44,123,2354,321,745,1231}
-- local subset = table.move(values, 5, 7, 1, {})
