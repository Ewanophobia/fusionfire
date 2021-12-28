--!strict
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local AudioVisualiserModule = require(ReplicatedStorage.Shared.AudioVisualizer)
local Promise = require(Knit.Util.Promise)

local AudioController = Knit.CreateController { Name = "AudioController" }

local Shared = Knit.Shared
local Logger = Knit.Logger

local IDConverter = require(Shared.Util.IDConverter)

local SoundGroup = SoundService:WaitForChild("SoundGroup")
local Sound = SoundGroup:WaitForChild("Sound")

local BAR_COUNT = 150

function AudioController:KnitInit()
	self.MusicService = Knit.GetService("MusicService")
end

function AudioController:CaptureAudio(frame: Frame)
	self.AudioVisualiser = AudioVisualiserModule.new(frame, BAR_COUNT)
	self.AudioVisualiser:LinkToSound(Sound)
end

function AudioController:StopCapturingAudio()
	self.AudioVisualiser:UnlinkFromSound()
end

function AudioController:GetAudioInfo()
	local worked, song = self.MusicService:GetCurrentSong():await()

	if worked then
		local newId = IDConverter.fromUrl(song.SoundId)

		if not worked then
			Logger:Warn("[AudioController] Failed to retrieve playing song, {:?}", song)
		end

		return Promise.async(function(resolve, reject)
			local success, result = pcall(function()
				return MarketplaceService:GetProductInfo(newId, Enum.InfoType.Asset)
			end)

			if success then
				resolve(result)
			else
				reject(result)
			end
		end)
	end
end

return AudioController
