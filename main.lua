require("onScreenKeyboard")

local textField = display.newText("", 0, 0, display.contentWidth, 100, native.systemFont, 50)
textField:setTextColor(255, 255, 255)

local keyboard = onScreenKeyboard:new()
--create a listener function that receives the events of the keyboard
local listener = function(event)
    if (event.phase == "ended") then
        textField.text = keyboard:getText()
        textField.anchorX = 0
        textField.anchorY = 0
        textField.x = 0
        textField.y = 0

        if (event.target.inputCompleted == true) then
            print("Input of data complete...")
            keyboard:destroy()
        end
    end
end

keyboard:setListener(listener)
keyboard:drawKeyBoard(keyboard.keyBoardMode.letters_small)
