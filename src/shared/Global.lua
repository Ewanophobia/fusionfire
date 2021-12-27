local RunService = game:GetService("RunService")

local makeEnum = require(script.Parent.makeEnum)
local quickAnimation = require(script.Parent.quickAnimation)

local Global = {}

Global.PLACES = { -- {PRODUCTION|INTEGRATION|DEBUG_ENABLED_IN}
	PRODUCTION = {}, -- #[int]
	INTEGRATION = {}, -- #[int]
	DEBUG_ENABLED_IN = {} -- #[int]
}

----------------
-- VERSIONING --
----------------
Global.VERSION_MAJOR = 0 -- #int
Global.VERSION_MINOR = 0 -- #int
Global.VERSION_PATCH = 0 -- #int
Global.VERSION = string.format("%i.%i.%i", Global.VERSION_MAJOR, Global.VERSION_MINOR, Global.VERSION_PATCH) -- #string
Global.BUILD = 1000

Global.ENVIRONMENT = -- #enum development | staging | production
	(RunService:IsStudio() and "development")
	or (table.find(Global.PLACES.PRODUCTION, game.PlaceId) and "production")
	or "staging"

----------------
-- ANIMATIONS --
----------------
Global.ANIMATIONS = {
	RIFLE_RELOAD = quickAnimation("rbxassetid://8358458823"),
	RIFLE_SHOOT = quickAnimation("rbxassetid://8358457133"),
	RIFLE_HOLD = quickAnimation("rbxassetid://8358456004"),

	PISTOL_RELOAD = quickAnimation("rbxassetid://8358453975"),
	PISTOL_SHOOT = quickAnimation("rbxassetid://8358479573"),
	PISTOL_HOLD = quickAnimation("rbxassetid://8358450816"),

	FRONT_FLIP = quickAnimation("rbxassetid://8367284453"),
}

-------------
-- GENERAL --
-------------

Global.MOUSE_ICONS = {
	DEFAULT = "rbxassetid://8369244188",
}

-----------
-- STATS --
-----------

-----------
-- DEBUG --
-----------
Global.ENABLE_DEBUG_IN_STUDIO = true -- #boolean
Global.DEBUG_ENABLED = -- #boolean [dynamic]
	(table.find(Global.PLACES.DEBUG_ENABLED_IN, game.PlaceId) and true)
	or (RunService:IsStudio() and Global.ENABLE_DEBUG_IN_STUDIO)

----------
-- KNIT --
----------
Global.SERVER_READY_FLAG_NAME = "ServerReady" -- #string

-- Strict
setmetatable(Global, {
	__index = function(_, k)
		-- Deprecation
		if k == "Badges" then
			warn("[Global] 'Badges' is deprecated in favour of 'BADGES', please use the correct entry")
			return Global.BADGES
		end

		error(string.format("'%s' is not a member of Global!", k), 2)
	end,

	__newindex = function()
		error("Creating new members in Global is not allowed!", 2)
	end,
})

if Global.DEBUG_ENABLED then
	print("----------------------------------------")
	print("[Global Debug]")
	print(Global)
	print("----------------------------------------")
else
	print("[Global] Debug is not enabled")
end

return Global
