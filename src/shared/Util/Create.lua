local function Create(className: string, properties: { [string]: any })
	local instance = Instance.new(className)

	for index, value in pairs(properties) do
		instance[index] = value
	end

	return instance
end

return Create
