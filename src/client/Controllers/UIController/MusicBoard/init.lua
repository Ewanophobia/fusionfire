local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Fusion = require(Knit.Library.Fusion)

local New = Fusion.New
local Children = Fusion.Children

local VisualizationFrame = require(script.VisualizationFrame)
local Logo = require(script.Logo)
local Subtext = require(script.Subtext)
local Title = require(script.Title)

local function MusicBoard(props)
	return {
		New "SurfaceGui" {
			Adornee = props.Adornee,
			Brightness = props.Brightness,
			Face = props.Face,
			Name = "MusicBoard",

			[Children] = {
				Logo {
					Image = "rbxassetid://137654765"
				},

				Title {
					Text = "TestTitle"
				},

				Subtext {
					Text = "TestSubtext"
				},

				VisualizationFrame {},
			}
		}
	}
end

return MusicBoard
