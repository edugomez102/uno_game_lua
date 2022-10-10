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
    x = 48, y = 342
  },
  gui_text = {
    x = 144, y = 342
  },
  restart = {
    x = 1170, y = 29,
    w = Card.w, h = Card.h
  },
  deck = {
    x = 732, y = 83,
    w = Card.w, h = Card.h
  },
  endgame = {
    bg = {
      x = 0, y = 0,
      w = 250, h = 150,
      color = {255, 0, 0}
    },
    text = {
      x = 0, y = 0
    },
    close = {
      x = 0, y = 50,
      w = 100, h = 80,
      color = {0, 255, 0}
    },
    restart = {
      x = 250, y = 50,
      w = 100, h = 80,
      color = {0, 255, 0}
    }
  }
}
