-- ============================================================
--  SOCCER HUB · Inf Stamina  (INS-ui front-end)
--  INS-ui is the Matcha Drawing UI lib used by BetterVoid.
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
local function applyStamina(v)
	pcall(applygc, numericEntries(), v and HACKED or ORIGINAL)
end

-------------------------------------------------- safe re-run
if _G.INF_STAM and _G.INF_STAM.unload then pcall(_G.INF_STAM.unload) end
local S = { on = true, running = true }
_G.INF_STAM = S

-------------------------------------------------- load INS-ui
local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/neaxusxgod-png/INS-ui/main/uilib.min.lua"))()
assert(Lib and Lib.CreateWindow, "INS-ui failed to load")

local win = Lib:CreateWindow({
	title    = "Soccer Hub",
	subtitle = "Unlimited Stamina",
	size     = Vector2.new(560, 360),
	position = Vector2.new(60, 60),
	menuKey  = "p",
	accentA  = Color3.fromRGB(92, 220, 140),
	accentB  = Color3.fromRGB(60, 180, 120),
	theme    = { accent = Color3.fromRGB(92, 220, 140) },
	opacity  = 0.95,
	rounding = 1,
	rowLines = true,
	keybindOverlay = true,
	startOpen = true,
})

local tab     = win:Tab("Stamina", "zap")
local controls = tab:Section("Controls", "Left",  "toggle + keybinds")
local status   = tab:Section("Status",   "Right", "live state")

-------------------------------------------------- unload
function S.unload()
	S.running = false
	pcall(function()
		if win then
			if win.Destroy then win:Destroy() elseif win.Unload then win:Unload() end
		end
	end)
	pcall(function() if Lib and Lib.Destroy then Lib:Destroy() end end)
	_G.INF_STAM = nil
end

-------------------------------------------------- controls
local toggle = controls:Toggle("Unlimited Stamina", true, function(v)
	S.on = v and true or false
	applyStamina(S.on)
end)
if toggle and toggle.AddKeybind then
	toggle:AddKeybind("g", "Toggle")   -- G = quick on/off
end

controls:Divider("System")
controls:Button("Unload", function() S.unload() end):SetRisk()

status:Label(function() return "Stamina: " .. (S.on and "ON" or "OFF") end)
status:Label(function() return "Menu key: P  ·  Quick: G" end)

-------------------------------------------------- apply initial ON + reassert
applyStamina(true)
task.spawn(function()
	while S.running and _G.INF_STAM == S do
		task.wait(5)
		if S.on then applyStamina(true) end
	end
end)
