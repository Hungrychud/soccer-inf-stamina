-- ============================================================
--  SOCCER HUB · Inf Stamina  (Nexa-UI front-end)
--  Nexa-UI is a Drawing-based lib (works in Matcha's VM).
--  Stamina patched via getgc/applygc on Sprint Constants.
-- ============================================================

-------------------------------------------------- stamina patch core
local KEYS = { "DrainDuration", "RefillDuration", "JumpStaminaCost", "StaminaCost" }
local ORIGINAL = { DrainDuration = 11,     RefillDuration = 3.5, JumpStaminaCost = 0.05 }
local HACKED   = { DrainDuration = 999999, RefillDuration = 0.1, JumpStaminaCost = 0, StaminaCost = 0 }

local function numericEntries()
	local nums = {}
	for _, e in ipairs(getgc(KEYS)) do
		if e.type == "number" then table.insert(nums, e) end
	end
	return nums
end
local function apply(on)
	pcall(applygc, numericEntries(), on and HACKED or ORIGINAL)
end

-------------------------------------------------- safe re-run (unload old UI)
if _G.INF_NEXA then pcall(function() _G.INF_NEXA:Destroy() end) end
if _G.INF_STAMINA then pcall(_G.INF_STAMINA.stop) end  -- kill old Drawing panel

local on = true

-------------------------------------------------- load Nexa-UI
local src = game:HttpGet("https://raw.githubusercontent.com/OgTen/Nexa-UI/main/nexa-ui.lua")
loadstring(src)()
local Nexa = Nexa or rawget(getfenv(0), "Nexa")  -- lib sets a global
assert(Nexa and Nexa.CreateWindow, "Nexa-UI failed to load")
_G.INF_NEXA = Nexa

-------------------------------------------------- build window
Nexa:CreateWindow({
	Title    = "Soccer Hub",
	Subtitle = "Unlimited Stamina",
	Width    = 540,
	Height   = 380,
	Theme    = "Midnight",
})
Nexa:SetKeybind("rightshift") -- RightShift toggles the menu

local main = Nexa:AddTab({ Title = "Main", Icon = "home", Select = true })

local sec = main:AddSection("Stamina", "Drains to ~0, instant refill, free jumps.", { Column = "left" })

-- main toggle (starts ON)
local staminaToggle = sec:AddToggle({
	Title       = "Unlimited Stamina",
	Description  = "Patch Sprint Constants.",
	Default     = true,
})
staminaToggle:OnChanged(function(v)
	on = v
	apply(v)
	staminaToggle:SetDescription(v and "ACTIVE · no drain · free jumps" or "Disabled (originals restored).")
end)

-- a toggle-key for it (optional quick on/off)
staminaToggle:AddKeybind({
	Title   = "Stamina bind",
	Default = "g",
	Mode    = "Toggle",
})

-- unload section
local sys = main:AddSection("System", "Unload / menu controls.", { Column = "right" })
sys:AddKeybind({
	Title     = "Unload UI",
	Default   = "delete",
	Mode      = "Toggle",
	OnPressed = function()
		pcall(function() Nexa:Destroy() end)
	end,
})
sys:AddButton({
	Title      = "Unload now",
	ButtonText = "Unload",
	Variant    = "danger",
	Callback   = function() pcall(function() Nexa:Destroy() end) end,
})

-------------------------------------------------- apply initial ON state
apply(true)
staminaToggle:SetDescription("ACTIVE · no drain · free jumps")

-- keep reasserting while UI alive
task.spawn(function()
	while _G.INF_NEXA == Nexa do
		task.wait(5)
		if on then apply(true) end
	end
end)
