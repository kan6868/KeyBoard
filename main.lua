local Keyboard = require("KeyBoard")

local jumpKey = "Jump"

Keyboard.RegisterCustomKey("a", jumpKey)

Keyboard.RegisterCustomKey("b", jumpKey) -- replace key a to b

local function enterFrame()

    if Keyboard.justPressed(jumpKey) then
        print("Press Jump key")
    elseif Keyboard.justReleased(jumpKey) then
        print("Release Jump key")
    end
    
    if Keyboard.justPressed("b") then
        print("b")
    end
end

Runtime:addEventListener("enterFrame", enterFrame)