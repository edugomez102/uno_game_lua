# UNO card game in lua

following the [oficial rules](https://en.wikipedia.org/wiki/Uno_(card_game))

## Differences with real game

* Can't say UNO when a player has one card left
* Action cards can't appear as first card

## Quick Guide

1. go to `main.lua` and change human to false if you want the player to be
AI controlled
2. run `lua main.lua`

```lua
local players = {
  Player.new({name = "Kevin", human = true}),
  Player.new({name = "John",  human = false}),
  Player.new({name = "Pablo", human = false}),
}
```
