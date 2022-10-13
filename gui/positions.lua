local Card = require('uno.card')

local card_scale = 1 / 3.35
local s_card_reduction = 0.75

return {
  current_card = {
    x = 568, y = 83,
    scale = 1 / 1.675
  },
  card_list = {
    x = 42, y = 537,
    scale = card_scale,
    margin = 8.27 + Card.w,
  },
  card_list_s = {
    x = 42, y1 = 502, y2 = 599,
    scale = card_scale * s_card_reduction,
    margin = 9.5 + Card.w * s_card_reduction,
    reduction = s_card_reduction
  },
  player_list = {
    x = 56, y = 391,
    margin = 33.66
  },
  direction = {
    x = 48, y = 342
  },
  gui_text = {
    x = 144, y = 342
  },
  restart = {
    x = 1150, y = 29,
    w = Card.h, h = Card.w,
    color = {0.5, 1 ,1}
  },
  deck = {
    x = 732, y = 83,
    scale = 1 / 3.35,
    w = Card.w, h = Card.h
  },
  endgame = {
    bg = {
      x = 139, y = 87,
      w = 400, h = 235,
      color = {44 / 255, 44 / 255, 45 / 255}
    },
    text = {
      x = 149, y = 97
    },
    close = {
      x = 0, y = 50,
      w = 100, h = 80,
      color = {0, 255, 0}
    },
    restart = {
      x = 200, y = 50,
      w = 100, h = 80,
      color = {0, 255, 0}
    }
  }
}
