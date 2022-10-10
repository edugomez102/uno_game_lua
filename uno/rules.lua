local Rules = {}

---Checks if number in _current_card and card_to_play are the same
---@param card_to_play table Card
---@param current_card table Card
function Rules.checkNumber(card_to_play, current_card)
  if current_card.number == card_to_play.number or
    card_to_play.number == "any" then
    return true
  else
    return false
  end
end

---Checks if color in _current_card and card_to_play are the same
---@param card_to_play table Card
---@param current_card table Card
function Rules.checkColor(card_to_play, current_card)
  if current_card.color == card_to_play.color or
    card_to_play.color == "K" then
    return true
  else
    return false
  end
end

---Checks both number and color
---
---@param card_to_play table Card
---@param current_card table Card
function Rules.checkNumberAndColor(card_to_play, current_card)
  if Rules.checkNumber(card_to_play, current_card) or
    Rules.checkColor(card_to_play, current_card) then
    return true
  end
  return false
end

---Checks if player has no cards so it has won the game
---
---@return boolean true if the game ends
function Rules.checkLastCard(player)
  if player.getCardNumber() == 0 then return true
  else return false end
end

---Checks if played card is an action card and calls its function
---
---@param card table Card to check
---@param action_cards table list of actions cards and their functions
---@param turn table containing game turn info
---@param player_list table list of players
---@return boolean true if action card requires player to change color
function Rules.checkActionCard(action_cards, card, turn, player_list)
  if table.has_key(action_cards, card.number) then
    action_cards[card.number](turn, player_list[turn.index])
    if string.find(card.number, "wild") then return true end
  end
  return false
end

return Rules

