--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local function quickSound(audioId: number, volume: number?)
	local playerGui = Knit.Player:FindFirstChild("PlayerGui")

	if not playerGui then
		return false
	end

	local sound = Instance.new("Sound")
	sound.SoundId = "rbxassetid://" .. audioId
	sound.Volume = volume or 0.5
	sound.PlayOnRemove = true
	sound.Parent = Knit.Player.PlayerGui

	sound:Destroy()
end

return quickSound
