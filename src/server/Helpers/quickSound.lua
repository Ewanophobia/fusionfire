--!strict

local function quickSound(audioId: number, volume: number?, parent: Instance?)
	local sound = Instance.new("Sound")
	sound.SoundId = "rbxassetid://" .. audioId
	sound.Volume = volume or 0.5
	sound.PlayOnRemove = true
	sound.Parent = parent or workspace

	sound:Destroy()
end

return quickSound
