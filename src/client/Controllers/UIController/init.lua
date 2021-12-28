local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Fusion = require(Knit.Library.Fusion)

local New = Fusion.New
local Children = Fusion.Children

local UIController = Knit.CreateController({
	Name = "UIController",
})

local MusicBoard = require(script.MusicBoard)

function UIController:KnitStart()
	local AudioController = Knit.GetController("AudioController")

	New "ScreenGui" {
		Parent = Knit.Player:WaitForChild("PlayerGui", math.huge),

		ZIndexBehavior = Enum.ZIndexBehavior.Global,
		DisplayOrder = 90,
		IgnoreGuiInset = true,
		Name = "Fusionfire",

		[Children] = {
			MusicBoard {
				Adornee = workspace:WaitForChild("Part"),
				Brightness = 2.5,
				Face = Enum.NormalId.Back
			}
		}
	}

	local ScreenGui = Knit.Player.PlayerGui:WaitForChild("Fusionfire")
	local MusicBoard = ScreenGui:WaitForChild("MusicBoard")
	MusicBoard.Parent = workspace:WaitForChild("Part")

	local Frame = MusicBoard:WaitForChild("Frame")
	AudioController:CaptureAudio(Frame)
end

return UIController
