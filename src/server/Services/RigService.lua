local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Knit = require(ReplicatedStorage.Packages.Knit)

local RigService = Knit.CreateService {
	Name = "RigService",
	Client = {},
}

local Assets = Knit.Assets
local Library = Knit.Library

local t = require(Library.t)

local Rig = Assets:WaitForChild("Rig")

function RigService:KnitInit()

end

function RigService:ApplyRig(player)
	local Character = player.Character or player.CharacterAdded:Wait()
	local Humanoid = Character:WaitForChild("Humanoid")

	for _, part in ipairs(Rig:GetDescendants()) do
		if part:IsA("BasePart") then
			Humanoid:ReplaceBodyPartR15(Enum.BodyPartR15[part.Name], part:Clone())
		end
	end

	Humanoid.Died:Connect(function()
		self:ApplyRig(player)
	end)
end

function RigService:KnitStart()
	Players.PlayerAdded:Connect(function(player)
		self:ApplyRig(player)
	end)

	for _, player in ipairs(Players:GetPlayers()) do
		self:ApplyRig(player)
	end
end

return RigService
