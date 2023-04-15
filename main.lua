local keyboard = require("KeyBoard")

local function enterFrame()
    if keyboard.pressed("u") then
        print("Pressing U")
    end

    if keyboard.justPressed("i") then
        print("Pressing i")
    end

    if keyboard.justReleased("b") then
        print("Released b")
    end
end

Runtime:addEventListener("enterFrame", enterFrame)