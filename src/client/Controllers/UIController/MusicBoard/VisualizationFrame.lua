local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Fusion = require(Knit.Library.Fusion)

local New = Fusion.New
local Children = Fusion.Children

local function VisualizationFrame()
	return New "Frame" {
		BackgroundColor3 = Color3.fromRGB(),
		BackgroundTransparency = 0.9,
		Size = UDim2.fromScale(1, 0.635)
	}
end

return VisualizationFrame
