local Game = require("game")
local Player = require("player")

local p1 = Player:new({name = "p1", cards = {}})
local p2 = Player:new({name = "p2", cards = {}})
local p3 = Player:new({name = "p3", cards = {}})

local game = Game:new()

game:addPlayer(p1)
game:addPlayer(p2)
game:addPlayer(p3)

game:start()

-- p1:printCards()
-- p2:printCards()
-- p3:printCards()

-- while true do
	game:play()
-- end
