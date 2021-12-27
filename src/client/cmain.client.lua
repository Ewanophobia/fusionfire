local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local function WaitForAttribute(instance, attributeName)
	local attribute = instance:GetAttribute(attributeName)
	if not attribute then
		instance:GetAttributeChangedSignal(attributeName):Wait()
		attribute = instance:GetAttribute(attributeName)
	end
end

local function startClient()
	local Knit = require(ReplicatedStorage.Packages.Knit)
	local recursive = require(ReplicatedStorage.Shared.knitLoader)(Knit)

	-- Client-side folder injection
	Knit.Helpers = script.Parent.Helpers

	-- Load controllers
	-- ⚠ This means that controllers will sometimes be required BEFORE the server
	--- is ready.
	recursive(script.Parent.Controllers, require)

	-- Wait for server before we start Knit.
	-- The 'math.huge' is to surpress 'Infinite yield possible' warnings.
	WaitForAttribute(ReplicatedStorage, Knit.Global.SERVER_READY_FLAG_NAME)
	-- Start Knit
	Knit.Start():andThen(function()
		Knit.Logger:Info("[cmain] Client has started! Running version {:?} in environment {:?}.", Knit.Global.VERSION, Knit.Global.ENVIRONMENT)
	end):catch(function(err)
		Knit.Logger:Warn("[cmain] A fatal error occurred while starting Knit: {:?}", err)

		-- Disconnnect client if the game won't load
		Players.LocalPlayer:Kick("A fatal error occurred while starting the game, please rejoin.")
	end)
end

startClient()
