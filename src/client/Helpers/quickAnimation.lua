--!strict

local function quickAnimation(Player: Player, AnimationID: string)
	local Character = Player.Character or Player.CharacterAdded:Wait()
	local Humanoid = Character:WaitForChild("Animator")
	local Animator = Humanoid:WaitForChild("Animator")

	local animation = Instance.new("Animation")
	animation.AnimationId = AnimationID

	return Animator:LoadAnimation(Animator)
end
