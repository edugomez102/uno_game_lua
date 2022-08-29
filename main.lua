local Game = require("game")
local Player = require("player")

local p1 = Player.new("p1")
local p2 = Player.new("p2")
local p3 = Player.new("p3")
local p4 = Player.new("p4")

local game = Game:new()

game.addPlayer(p1)
game.addPlayer(p2)
game.addPlayer(p3)
game.addPlayer(p4)

game.start()

-- print(tostring(p1:getCard(1)))
-- p1:printCards()
-- p2:printCards()
-- p3:printCards()

while true do
	game.play()
end

