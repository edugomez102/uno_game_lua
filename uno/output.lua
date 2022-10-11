local Output = { }

---Prints number of cards left by player when game ends
---
---@param player_list table
function Output.playersCardsLeft(player_list)
  local t = {}
  for i = 1, #player_list do
    t[#t+1] = player_list[i].name .. " had " ..
    player_list[i].getCardNumber() .. " cards left\n"
  end
  t[#t+1] = "\nClick on restart or close the window"
  return table.concat(t)
end

---Prints played card
---
---@param player table Player
---@param card_to_play table Card
function Output.playedCard(player, card_to_play)
  return player.name .. " played card: " .. card_to_play.__tostring() .. "\n"
end

---Print changed color
---
---@param player table Player
---@param color string Color
function Output.colorChange(player, color)
  return player.name .. " changed color to " .. color, "\n"
end

function Output.playerDraws(player, card)
  if player.isHuman() then
    return player.name .. " draws card " .. card.__tostring() .. "\n"
  else
    return player.name .. " draws a card\n"
  end
end

function Output.turnPass(player)
  return player.name .. " has passed their turn\n"
end

function Output.cantPlay(card_str)
  return "CANT PLAY THAT CARD: " .. card_str .. "\n"
end

function Output.wrongNumberPlayers()
  io.write("Wrong number of players, must be between 2 and 10\n")
end

return Output
