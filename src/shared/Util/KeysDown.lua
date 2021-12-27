local userInput = game:GetService("UserInputService")

local keysDown = {}

for _,keyCode in ipairs(Enum.KeyCode:GetEnumItems()) do
	keysDown[keyCode] = false
end

local function IsDown(keyCode)
	return keysDown[keyCode]
end

userInput.InputBegan:Connect(function(input, processed)
	if (processed) then return end
	if (input.UserInputType == Enum.UserInputType.Keyboard) then
		keysDown[input.KeyCode] = true
	end
end)

userInput.InputEnded:Connect(function(input, processed)
	if (input.UserInputType == Enum.UserInputType.Keyboard) then
		keysDown[input.KeyCode] = false
		if (processed) then return end
	end
end)

return keysDown
