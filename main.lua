require("onScreenKeyboard")         -- include the onScreenKeyboard.lua file
--create a textfield for the content created with the keyoard
local textField = display.newText("", 0, 0, display.contentWidth, 100, native.systemFont, 50)
textField:setTextColor(255, 255, 255)
--create an instance of the onScreenKeyboard class without any parameters. This creates a keyboard
--with the default values. You can manipulate the visual representation of the keyboard by passing a table to the new() function.
--Read more about this in the section "customizing the keyboard style"
local keyboard = onScreenKeyboard:new()
--create a listener function that receives the events of the keyboard
local listener = function(event)
    if (event.phase == "ended") then
        textField.text = keyboard:getText()       --update the textfield with the current text of the keyboard
        -- textField:setReferencePoint(display.TopLeftReferencePoint)
        textField.anchorX = 0
        textField.anchorY = 0
        textField.x = 0
        textField.y = 0
        --check whether the user finished writing with the keyboard. The inputCompleted
        --flag of  the keyboard is set to true when the user touched its "OK" button
        if (event.target.inputCompleted == true) then
            print("Input of data complete...")
            keyboard:destroy()
        end
    end
end
--let the onScreenKeyboard know about the listener
keyboard:setListener(listener)
--show a keyboard with small printed letters as default. Read more about the possible values for keyboard types in the section "possible keyboard types"
keyboard:drawKeyBoard(keyboard.keyBoardMode.letters_small)
