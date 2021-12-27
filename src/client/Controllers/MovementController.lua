--!strict
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Knit = require(ReplicatedStorage.Packages.Knit)

local Player = Knit.Player
local Logger = Knit.Logger
local Shared = Knit.Shared

local Mouse = require(Shared.Util.Mouse)
local KeysDown = require(Shared.Util.KeysDown)

local MovementController = Knit.CreateController { Name = "MovementController" }

local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

local relativeMovement = false

local WALK_KEYBINDS = {
	Forward = { Key = Enum.KeyCode.W, Direction = Enum.NormalId.Front },
	Backward = { Key = Enum.KeyCode.S, Direction = Enum.NormalId.Back },
	Left = { Key = Enum.KeyCode.A, Direction = Enum.NormalId.Left },
	Right = { Key = Enum.KeyCode.D, Direction = Enum.NormalId.Right }
}

local MOVEMENT_UPDATE_NAME = "UPDATE_MOVEMENT"

function MovementController:GetWalkDirectionCameraSpace()
	local direction = Vector3.new()

	for _, keyBind in pairs(WALK_KEYBINDS) do
		if KeysDown[keyBind.Key] then
			direction += Vector3.FromNormalId(keyBind.Direction)
		end
	end

	if direction.Magnitude > 0 then
		direction = direction.Unit
	end

	return direction
end

function MovementController:GetWalkDirectionWorldSpace()
	local direction = self:GetWalkDirectionCameraSpace()
	local walkDirection = HumanoidRootPart.CFrame:VectorToWorldSpace(direction)
	walkDirection *= Vector3.new(1, 0, 1)

	if walkDirection.Magnitude > 0 then
		walkDirection = walkDirection.Unit
	end

	return walkDirection
end

function MovementController:UpdateMovement()
	if Humanoid then
		local direction = self:GetWalkDirectionWorldSpace()
		Humanoid:Move(direction)
	end
end

function MovementController:UpdateDirection()
	if HumanoidRootPart then
		local forwardVector = (HumanoidRootPart.Position - Mouse.Hit.Position).Unit
		local rightVector = forwardVector:Cross(Vector3.yAxis)
		local cframe = CFrame.fromMatrix(
			HumanoidRootPart.Position,
			-rightVector,
			Vector3.yAxis
		)

		HumanoidRootPart.CFrame = cframe
	end
end

function MovementController:ToggleRelativeMovement()
	relativeMovement = not relativeMovement

	if relativeMovement then
		Humanoid.AutoRotate = false

		RunService:BindToRenderStep(MOVEMENT_UPDATE_NAME, Enum.RenderPriority.Camera.Value + 1, function()
			self:UpdateMovement()
			self:UpdateDirection()
		end)
	else
		Humanoid.AutoRotate = true
		RunService:UnbindFromRenderStep(MOVEMENT_UPDATE_NAME)
	end
end

function MovementController:KnitStart()
	self:ToggleRelativeMovement()

	Humanoid.Died:Connect(function()
		Character = Player.CharacterAdded:Wait()
		HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
		Humanoid = Character:WaitForChild("Humanoid")
	end)
end

return MovementController
