local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local Knit = require(ReplicatedStorage.Packages.Knit)

local JumpController = Knit.CreateController { Name = "JumpController" }

local Player = Knit.Player

local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Animator = Humanoid:WaitForChild("Animator")

local DEFAULT_JUMP_POWER = Humanoid.JumpPower
local TIME_BETWEEN_JUMPS = 0.1
local DOUBLE_JUMP_POWER_MULTIPLIER = 1.5

local canDoubleJump = false
local hasDoubleJumped = false

function JumpController:OnJumpRequest()
	if Humanoid:GetState() == Enum.HumanoidStateType.Dead then
		return
	end

	if canDoubleJump and not hasDoubleJumped then
		hasDoubleJumped = true
		Humanoid.JumpPower = DEFAULT_JUMP_POWER * DOUBLE_JUMP_POWER_MULTIPLIER
		Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end

function JumpController:KnitStart()
	UserInputService.JumpRequest:Connect(self.OnJumpRequest)

	Humanoid.StateChanged:connect(function(old, new)
		if new == Enum.HumanoidStateType.Landed then
			canDoubleJump = false
			hasDoubleJumped = false
			Humanoid.JumpPower = DEFAULT_JUMP_POWER
		elseif new == Enum.HumanoidStateType.Freefall then
			task.wait(TIME_BETWEEN_JUMPS)
			canDoubleJump = true
		end
	end)
end

return JumpController
