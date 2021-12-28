local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

local Signal = require(ReplicatedStorage.Packages.Signal)
local Knit = require(ReplicatedStorage.Packages.Knit)

local Logger = Knit.Logger
local Shared = Knit.Shared

local Playlist = require(script.Playlist)
local Promise = require(Knit.Util.Promise)
local IDConverter = require(Shared.Util.IDConverter)

local MusicService = Knit.CreateService {
	Name = "MusicService",
	Client = {
		Playing = Knit.CreateSignal(),
		Finished = Knit.CreateSignal(),
	},

	Playing = Signal.new(),
	Finished = Signal.new(),
}

local AudioGroup = Instance.new("SoundGroup")
AudioGroup.Parent = SoundService

local MusicQueue = {}

local VOLUME = 0.3

local paused = false

local function getSongInfo(id: string, assetType: Enum.InfoType)
	return Promise.async(function(resolve, reject)
		local success, result = pcall(function()
			return MarketplaceService:GetProductInfo(id, assetType)
		end)

		if success then
			resolve(result)
		else
			reject(result)
		end
	end)
end

local function createSound()
	local sound = Instance.new("Sound")
	sound.Volume = VOLUME
	sound.Parent = AudioGroup

	return sound
end

function MusicService:KnitInit()
	self:AddPlaylist()
	self:Shuffle()
	self.Audio = createSound()
end

function MusicService:Play(id: string?)
	if #MusicQueue <= 1 then
		self:AddPlaylist()
		self:Shuffle()
	end

	self.Audio.SoundId = id or MusicService:GetRandomSong()
	self.Audio:Play()

	local index = table.find(MusicQueue, id)
	table.remove(MusicQueue, index)

	self.Audio.Ended:Connect(function()
		local song = self:GetRandomSong()
		self:Play(song)
	end)
end

function MusicService:Pause()
	paused = not paused

	if not paused then
		self.Audio:Pause()
	else
		self.Audio:Resume()
	end
end

function MusicService:Shuffle()
	for i = #MusicQueue, 2, -1 do
		local random = math.random(i)
		MusicQueue[i], MusicQueue[random] = MusicQueue[random], MusicQueue[i]
	end

	return MusicQueue
end

function MusicService:AddPlaylist()
	for _, id in ipairs(Playlist) do
		table.insert(MusicQueue, id)
	end

	return MusicQueue
end

function MusicService:GetRandomSong()
	return MusicQueue[math.random(1, #MusicQueue)]
end

function MusicService:GetCurrentSong()
	return self.Audio
end

function MusicService.Client:GetCurrentSong()
	return MusicService.Audio
end

function MusicService:GetSongInfo(player, id)
	local newId = IDConverter.fromUrl(id)

	getSongInfo(newId):andThen(function(result)
		return result
	end):catch(function(err)
		Logger:Warn("[MusicService] Failed to get info about song, {:?}", err)
	end)
end

function MusicService:KnitStart()
	self:Play()
end

return MusicService
