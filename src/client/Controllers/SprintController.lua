--!strict
local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Knit = require(ReplicatedStorage.Packages.Knit)

local Player = Knit.Player
local Logger = Knit.Logger
local Character = Player.Character or Player.CharacterAdded:Wait()

local Humanoid = Character:WaitForChild("Humanoid")

local Camera = workspace.CurrentCamera

local SprintController = Knit.CreateController { Name = "SprintController" }

local sprintEnabled = false

local SPRINT_FOV = 25
local SPRINT_SPEED = Humanoid.WalkSpeed + 10

local DEFAULT_FOV = 20
local DEFAULT_SPRINT_SPEED = Humanoid.WalkSpeed

local SPRINT_ACTION = "Sprint"

local TWEEN_INFO = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

local function tween(instance: Instance, properties: table)
	return TweenService:Create(instance, TWEEN_INFO, properties)
end

function SprintController:KnitInit()
	self.CameraController = Knit.GetController("CameraController")
end

function SprintController:ToggleSprint()
	sprintEnabled = not sprintEnabled

	if sprintEnabled then
		local fovTween = tween(Camera, {
			FieldOfView = SPRINT_FOV
		})

		local speedTween = tween(Humanoid, {
			WalkSpeed = SPRINT_SPEED
		})

		fovTween:Play()
		speedTween:Play()
	else
		local fovTween = tween(Camera, {
			FieldOfView = DEFAULT_FOV
		})

		local speedTween = tween(Humanoid, {
			WalkSpeed = DEFAULT_SPRINT_SPEED
		})

		fovTween:Play()
		speedTween:Play()
	end
end

function SprintController:KnitStart()
	local function handleSprint(actionName, inputState)
		if actionName == SPRINT_ACTION then
			if inputState == Enum.UserInputState.Begin then
				self:ToggleSprint()
			elseif inputState == Enum.UserInputState.End then
				self:ToggleSprint()
			end
		end
	end

	ContextActionService:BindAction(SPRINT_ACTION, handleSprint, true, Enum.KeyCode.LeftShift)
end

return SprintController
