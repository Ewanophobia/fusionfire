local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Fusion = require(Knit.Library.Fusion)

local New = Fusion.New
local Children = Fusion.Children
local State = Fusion.State
local Computed = Fusion.Computed

local function Title(props)
	local SongName = State("Unknown Song")
	local AudioController = Knit.GetController("AudioController")

	return {
		New "TextLabel" {
			Text = Computed(function()
				local worked, result = AudioController:GetAudioInfo():await()

				if worked then
					SongName:set(result.Name)
				end

				return SongName:get()
			end),

			TextColor3 = Color3.fromRGB(255, 255, 255),
			Font = Enum.Font.GothamBold,
			TextScaled = true,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.fromScale(0.6, 0.1),
			Position = UDim2.fromScale(0.5, 0.7),
			BackgroundTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Left,

			[Children] = {
				New "UIStroke" {
					Thickness = 2
				}
			}
		}
	}
end

return Title
