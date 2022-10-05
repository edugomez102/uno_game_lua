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

---Checks if player has no cards so it has won the game
---
---@return boolean true if the game ends
function Rules.checkLastCard(player)
  if player.getCardNumber() == 0 then
    love.event.quit()
    return true
  else
    return false
  end
end

return Rules

