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

function love.load()
  love.window.setMode(1280, 720)
  game.start()
end

function love.update(dt)
  game.play()
  game.input()
end

function love.draw()
  game.draw()
end

