local Game = require("game")
local Player = require("player")

local players = {
	Player.new({name = "P1", human = true}),
	Player.new({name = "P2", human = true}),
	Player.new({name = "P3", human = true}),
	Player.new({name = "P4", human = true}),
}

local game = Game.new()

for i = 1, #players do
	game.addPlayer(players[i])
end

game.start()

while not game.has_ended do
	game.play()
end

