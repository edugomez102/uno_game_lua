local Card = require('uno.card')
return {
  current_card = {
    x = 568, y = 83,
    scale = 2
  },
  card_list = {
    x = 42, y = 537,
    margin = 8.27 + Card.w
  },
  card_list_s = {
    x = 42, y1 = 502, y2 = 599,
    scale = 0.75,
    margin = 9.5 + Card.w * 0.75
  },
  player_list = {
    x = 44, y = 391,
    margin = 33.66
  },
  direction = {
    x = 30, y = 336
  },
  gui_text = {
    x = 139, y = 336
  },
  exit = {
    x = 1170, y = 29
  },
  deck = {
    x = 712, y = 83
  }
}
