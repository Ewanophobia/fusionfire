--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local Knit = require(ReplicatedStorage.Packages.Knit)
local UserPermissions = require(Knit.Shared.UserPermissions)

local RoleController = Knit.CreateController { Name = "RoleController" }

local Player = Knit.Player

local DISABLE_CONSOLE = "DISABLE_CONSOLE"

function RoleController:DisableConsole()
	RunService:BindToRenderStep(DISABLE_CONSOLE, 0, function()
		StarterGui:SetCore("DevConsoleVisible", false)
	end)
end

function RoleController:KnitStart()
	if not UserPermissions:HasRight(Player, "Developer") then
		self:DisableConsole()
	end
end

return RoleController
