local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Fusion = require(Knit.Library.Fusion)

local New = Fusion.New
local Children = Fusion.Children

local function Logo(props)
	return {
		New "ImageLabel" {
			Size = UDim2.fromScale(0.15, 0.3),
			Position = UDim2.fromScale(0.1, 0.8),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Image = props.Image,

			[Children] = {
				New "UICorner" {}
			}
		}
	}
end

return Logo
