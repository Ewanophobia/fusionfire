--!strict
local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local Knit = require(ReplicatedStorage.Packages.Knit)

local Player = Knit.Player
local Logger = Knit.Logger
local Shared = Knit.Shared
local Global = Knit.Global

local Create = require(Shared.Util.Create)
local Mouse = require(Shared.Util.Mouse)

local Character = Player.Character or Player.CharacterAdded:Wait()

local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Animator = Humanoid:WaitForChild("Animator")

local DashController = Knit.CreateController { Name = "DashController" }

local dashCooldown = false

local DASH_POWER = 1250
local DASH_SPEED = 50
local DASH_COOLDOWN = 4
local DASH_ACTION = "Dash"

local function setMouseBehaviour(behaviour: Enum.MouseBehavior)
	while true do
		UserInputService.MouseBehavior = behaviour

		if UserInputService.MouseBehavior == behaviour then
			break
		end

		task.wait()
	end
end

function DashController:KnitInit()
	self.CameraController = Knit.GetController("CameraController")
end

function DashController:Dash()
	if dashCooldown then
		return
	end

	if Humanoid.FloorMaterial == Enum.Material.Air then
		return
	end

	dashCooldown = true
	setMouseBehaviour(Enum.MouseBehavior.LockCurrentPosition)

	local animation = Animator:LoadAnimation(Global.ANIMATIONS.FRONT_FLIP)
	animation:AdjustSpeed(animation.Length / animation.Speed)
	animation:Play()

	local bodyVelocity = Create("BodyVelocity", {
		MaxForce = Vector3.new(math.huge, math.huge, math.huge),
		P = DASH_POWER,
		Velocity = (HumanoidRootPart.CFrame - Mouse.Hit.Position).LookVector * DASH_SPEED,
		Parent = HumanoidRootPart,
	})

	animation:GetMarkerReachedSignal("FrontflipBegan"):Connect(function()
		bodyVelocity.Parent = HumanoidRootPart
	end)

	animation:GetMarkerReachedSignal("FrontflipEnded"):Connect(function()
		bodyVelocity:Destroy()
		animation:Stop()
	end)

	setMouseBehaviour(Enum.MouseBehavior.Default)
	task.wait(DASH_COOLDOWN)
	dashCooldown = false
end

function DashController:KnitStart()
	local function handleDash(actionName, inputState)
		if actionName == DASH_ACTION then
			if inputState == Enum.UserInputState.Begin then
				self:Dash()
			end
		end
	end

	ContextActionService:BindAction(DASH_ACTION, handleDash, true, Enum.KeyCode.F)
end

return DashController
