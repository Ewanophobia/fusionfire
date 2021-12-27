--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local makeEnum = require(Knit.Shared.makeEnum)
local Global = require(Knit.Shared.Global)

local MouseController = Knit.CreateController {
	Name = "MouseController",

	MouseIcons = makeEnum("MouseIcons", {
		Default = "DEFAULT"
	})
}

local Player = Knit.Player
local Mouse = Player:GetMouse()

function MouseController:SetIcon(iconName)
	local iconTexture = Global.MOUSE_ICONS[iconName]
	Mouse.Icon = iconTexture
end

function MouseController:KnitStart()
	self:SetIcon("DEFAULT")
end

return MouseController
