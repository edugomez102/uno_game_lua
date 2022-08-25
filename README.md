# UNO card game in lua

first time using lua I'm using this aproacch to OOP:

```lua

function Class()
  -- public memebrs
  local self = {
    public_member = 5
  }

  -- private memebrs
  local private_member1 = 1
  local private_member2 = 2

  -- private memebrs
  local function private_fun()
    return private_member1 + private_member2
  end

  -- public function
  function self.public_fun()
    print("add private memebers:" .. private_fun())
  end

  return self
end

```

