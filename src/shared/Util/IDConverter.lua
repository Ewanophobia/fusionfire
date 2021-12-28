local IDConverter = {}

function IDConverter.fromUrl(URL)
	local omitted = string.gsub(URL, "rbxassetid://", "")
	return tonumber(omitted)
end

function IDConverter.fromNumber(number)
	return "rbxassetid://" .. number
end

return IDConverter
