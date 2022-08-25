# UNO card game in lua

first time using lua I'm using this aproacch to OOP:

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

