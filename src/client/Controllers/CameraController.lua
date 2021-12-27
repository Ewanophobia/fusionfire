--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Knit = require(ReplicatedStorage.Packages.Knit)

local Logger = Knit.Logger
local Player = Knit.Player

local CameraController = Knit.CreateController({
	Name = "CameraController",
	
	FieldOfView = 20,
})

local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

local Camera = workspace.CurrentCamera
local DEFAULT_FOV = Camera.FieldOfView

local isometricCamera = false

local FOV = 20
local CAMERA_DEPTH = 64
local HEIGHT_OFFSET = 3

local UPDATE_CAMERA_NAME = "ISOMETRIC_UPDATE"

function CameraController:ToggleIsometric()
	isometricCamera = not isometricCamera

	if isometricCamera then
		Camera.FieldOfView = FOV

		if Character and HumanoidRootPart then
			RunService:BindToRenderStep(UPDATE_CAMERA_NAME, Enum.RenderPriority.Camera.Value, function()
				local rootPosition = HumanoidRootPart.Position + Vector3.new(0, HEIGHT_OFFSET, 0)
				local cameraPosition = rootPosition + Vector3.new(CAMERA_DEPTH, CAMERA_DEPTH, CAMERA_DEPTH)
				Camera.CFrame = CFrame.lookAt(cameraPosition, rootPosition)
			end)
		end
	else
		Camera.FieldOfView = DEFAULT_FOV
		RunService:UnbindFromRenderStep(UPDATE_CAMERA_NAME)
	end
end

function CameraController:KnitStart()
	self:ToggleIsometric()
	self.FieldOfView = FOV

	Humanoid.Died:Connect(function()
		Character = Player.CharacterAdded:Wait()
		HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
		Humanoid = Character:WaitForChild("Humanoid")
	end)
end

return CameraController
