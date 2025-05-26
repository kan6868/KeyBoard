--[[
    Keyboard Module
    Version: 1.0
    Lua version: 5.1
    License: MIT
    Copyright .Kan - 2023
    
    A keyboard input handling module for tracking key states (pressed, just pressed, just released)
    and providing axis-based input (horizontal/vertical) with customizable key mappings.
    
    @usage:
    -- In enterFrame event:
    if keyboard.justPressed("space") then
        -- Handle spacebar just pressed
    end
        
    if keyboard.justReleased("a") then
        -- Handle 'A' key just released
    end
    
    -- Get axis input
    local hAxis = keyboard.getHorizontalAxis() -- returns -1 (left), 0 (neutral), or 1 (right)
    local vAxis = keyboard.getVerticalAxis()   -- returns -1 (up), 0 (neutral), or 1 (down)
]]

local M = {}

-- Table to store key states
M.key = {}

-- Default key mappings for axis input
M.map = {
  axis = {
    left = {"left"},    -- Left arrow key
    right = {"right"},  -- Right arrow key
    up = {"up"},        -- Up arrow key
    down = {"down"}     -- Down arrow key
  }
}

--[[
    Internal function to handle key down events
    @param keyName: string - name of the key being pressed
]]
local function handlerKeyDown(keyName)
  if not M.key[keyName] then return false end
  local key = M.key[keyName]
  key.pressed = true
  -- Set current state: 2 means just pressed, 1 means held down
  if key.current > 0 then
    key.current = 1
  else
    key.current = 2
  end
end

--[[
    Internal function to handle key up events
    @param keyName: string - name of the key being released
]]
local function handlerKeyUp(keyName)
  if not M.key[keyName] then return false end
  local key = M.key[keyName]
  key.pressed = false
  -- Set current state: -1 means just released, 0 means not pressed
  if key.current > 0 then
    key.current = -1
  else
    key.current = 0
  end
end

--[[
    Key event listener function
    @param event: table - Corona key event
]]
local function key(event)
  local phase = event.phase
  local name = string.lower(event.keyName)
  
  local iName = name or "none"

  -- Initialize key state if not exists
  if not M.key[iName] then
    M.key[iName] = {
      pressed = false,  -- Is the key currently pressed
      current = 0,      -- Current state (0: up, 1: held, 2: just pressed, -1: just released)
      last = 0          -- Previous state
    }
  end

  -- Handle key down/up events
  if phase == "down" then
    handlerKeyDown(iName)
  elseif phase == "up" then
    handlerKeyUp(iName)
  end
end

--[[
    Configure custom key mappings for axis input
    @param options: table - contains arrays of key names for each direction
                    {
                        left = {"a", "left"}, 
                        right = {"d", "right"},
                        up = {"w", "up"},
                        down = {"s", "down"}
                    }
]]
function M.setAxis(options)
  local left = options.left or {"left"}
  local right = options.right or {"right"}
  local up = options.up or {"up"}
  local down = options.down or {"down"}

  M.map.axis = {
    left = left,    -- Array of keys for left movement
    right = right,  -- Array of keys for right movement
    up = up,        -- Array of keys for up movement
    down = down     -- Array of keys for down movement
  }
end

--[[
    Get horizontal axis input value (-1 = left, 0 = neutral, 1 = right)
    @return: number - horizontal axis value
]]
function M.getHorizontalAxis()
  local left, right = 0, 0
  
  -- Check all left keys
  for i = 1, #M.map.axis.left do
    local iLeft = M.map.axis.left[i]
    if M.pressed(iLeft) then
      left = -1
      break
    end
  end

  -- Check all right keys
  for i = 1, #M.map.axis.right do
    local iRight = M.map.axis.right[i]
    if M.pressed(iRight) then
      right = 1
      break
    end
  end

  return left + right
end

--[[
    Get vertical axis input value (-1 = up, 0 = neutral, 1 = down)
    @return: number - vertical axis value
]]
function M.getVerticalAxis()
    local up, down = 0, 0
    -- Check all up keys
    for i = 1, #M.map.axis.up do
        local iUp = M.map.axis.up[i]
        if M.pressed(iUp) then
            up = -1
            break
        end
    end

    -- Check all down keys
    for i = 1, #M.map.axis.down do
        local iDown = M.map.axis.down[i]
        if M.pressed(iDown) then
            down = 1
            break
        end
    end

    return up + down
end

--[[
    Check if a key is currently pressed
    @param keyName: string - name of the key to check
    @return: boolean - true if key is pressed
]]
function M.pressed(keyName)
  if not M.key[keyName] then return false end
  return M.key[keyName].pressed 
end

--[[
    Check if a key was just pressed this frame
    @param keyName: string - name of the key to check
    @return: boolean - true if key was just pressed
]]
function M.justPressed(keyName)
  if not M.key[keyName] then return false end
  return M.key[keyName].current == 2
end

--[[
    Check if a key was just released this frame
    @param keyName: string - name of the key to check
    @return: boolean - true if key was just released
]]
function M.justReleased(keyName)
  if not M.key[keyName] then return false end
  return M.key[keyName].current == -1
end

--[[
    Internal update function called every frame to manage key state transitions
]]
local function update()
  for key, value in pairs(M.key) do
    if value then
      -- Transition just released (-1) to not pressed (0)
      if value.last == -1 and value.current == -1 then
        value.current = 0
      -- Transition just pressed (2) to held down (1)
      elseif value.last == 2 and value.current == 2 then
        value.current = 1
      end
      value.last = value.current
    end    
  end
end

--[[
    Clean up the module by removing event listeners
]]
function M.clear()
  Runtime:removeEventListener("key", key)
  Runtime:removeEventListener("enterFrame", update)
end

-- Initialize event listeners
Runtime:addEventListener("key", key)
Runtime:addEventListener("enterFrame", update)

return M
