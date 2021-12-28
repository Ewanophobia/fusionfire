--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local UIService = Knit.CreateService({
	Name = "UIService",
	Client = {},
})

function UIService:KnitStart()
	
end

return UIService
