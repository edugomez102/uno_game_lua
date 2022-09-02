# UNO card game in lua

following the [oficial rules](https://en.wikipedia.org/wiki/Uno_(card_game))

## Differences with real game

* Can't say UNO when a player has one card left
* Action cards can't appear as first card

## Quick Guide

1. go to `main.lua` and change human to false if you want it to be AI controlled
2. run `lua main.lua`

```lua
local players = {
  Player.new({name = "Kevin", human = true}),
  Player.new({name = "John",  human = false}),
  Player.new({name = "Pablo", human = false}),
}
```

## first time using lua I'm using this aproacch to OOP

```lua

function Class(num)
  -- public memebrs
  local self = {
    public_member = 5
  }

  -- private memebrs
  local _private_member1 = num or 1
  local _private_member2 = 2

  -- private memebrs
  local function private_fun()
    return _private_member1 + _private_member2
  end

  -- public function
  function self.public_fun()
    print("add private memebers:" .. private_fun())
  end

  return self
end

```

