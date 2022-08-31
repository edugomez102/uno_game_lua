local Game   = require("game")
local Player = require("player")
require("table_")

local players = {
	Player.new({name = "P1", human = true}),
	Player.new({name = "P2", }),
	-- Player.new({name = "P3", human = true}),
	-- Player.new({name = "P4", human = true}),
}

local game = Game.new()

for i = 1, #players do
	game.addPlayer(players[i])
end

game.start()

while not game.hasEnded() do
	game.play()
end

