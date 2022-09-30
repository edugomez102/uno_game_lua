local Game   = require("uno.game")
local Player = require("uno.player")
require("modules.table_")

local players = {
	Player.new({name = "P1", human = true}),
	Player.new({name = "P2", human = false}),
	Player.new({name = "P3", human = false}),
	Player.new({name = "P4", human = false}),
}

local game = Game.new({sort_cards = true})

for i = 1, #players do
	game.addPlayer(players[i])
end

game.start()

while not game.hasEnded() do
	game.play()
end

