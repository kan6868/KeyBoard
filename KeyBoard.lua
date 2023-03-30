local M = {}

M.ANY_KEY = "any"

M.key = {}

M.customKey = {}

local function newKey(name, layout)
  local layout = layout or name

  M.key[name] = {}
  M.key[name].pressed = false
  M.key[name].current = 0
  M.key[name].last = 0
  M.key[name].layout = layout

  return M.key[name]
end

local function handlerKeyDown(keyName)
  if not M.key[keyName] then return false end
  local key = M.key[keyName]

  key.pressed = true
  if key.current > 0 then
    key.current = 1
  else
    key.current = 2
  end
end

local function handlerKeyUp(keyName)
  if not M.key[keyName] then return false end
  local key = M.key[keyName]
  key.pressed = false
  if key.current > 0 then
    key.current = -1
  else
    key.current = 0
  end
end

local function key(event)
  local phase = event.phase
  local name = event.keyName

  local iName = name or "none"

  if not M.key[iName] then
    newKey(iName)
  end

  if phase == "down" then
    
    if M.customKey[iName] then
      local action = M.customKey[iName]
      if not M.key[action] then
        newKey(action, iName)
      end
      handlerKeyDown(action)
    end
    
    handlerKeyDown(iName)
  elseif phase == "up" then
    if M.customKey[iName] then
      local action = M.customKey[iName]
      handlerKeyUp(action)
    end

    handlerKeyUp(iName)
  end

end

function M.loadCustomKey()
  --M.customKey = load() // load custom key data
end

function M.saveCustomKey()
  --save()
end

function M.RegisterCustomKey(key, action)
  for key, value in pairs(M.customKey) do
    if value == action then
      M.customKey[key] = nil
    end
  end

  M.customKey[key] = action
end

function M.pressed(keyName)
  if not M.key[keyName] then return false end
  return M.key[keyName].pressed 
end

function M.justPressed(keyName)
  if not M.key[keyName] then return false end
  return M.key[keyName].current == 2
end

function M.justReleased(keyName)
  if not M.key[keyName] then return false end
  return M.key[keyName].current == -1
end

local function update()
  for key, value in pairs(M.key) do
    if value then
      if value.last == -1 and value.current == -1 then
        value.current = 0
      elseif value.last == 2 and value.current == 2 then
        value.current = 1
      end
      value.last = value.current
    end    
  end
end

Runtime:addEventListener("key", key)
Runtime:addEventListener("enterFrame", update)
return M