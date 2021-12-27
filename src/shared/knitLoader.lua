local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function knitLoader(Knit)
	Knit.Shared = ReplicatedStorage:WaitForChild("Shared")
	Knit.Packages = ReplicatedStorage:WaitForChild("Packages")
	Knit.Library = ReplicatedStorage:WaitForChild("Library")
	Knit.Assets = ReplicatedStorage:WaitForChild("Assets")

	Knit.Logger = require(Knit.Shared.Logger)
	Knit.Global = require(Knit.Shared.Global)

	local function recursive(parent, callback)
		for _, child in ipairs(parent:GetChildren()) do
			if child:IsA("ModuleScript") then
				callback(child)
			elseif child:IsA("Folder") then
				recursive(child, callback)
			end
		end
	end

	return recursive
end

return knitLoader
