-- ============================================================
--  SOCCER HUB  ·  no UI, console only
--  Patches live game Constants via getgc/applygc. Features stay
--  on until you leave. Flip the flags below to pick features.
-- ============================================================

local CONFIG = {
	UnlimitedStamina = true,   -- drain ~0, instant refill, free jumps
	NoDodgeCooldown  = true,   -- dash/dodge with no cooldown
	AutoGoalkeeper   = true,   -- superhuman dive assist (perfect saves)
}

-- stop previous run
if _G.SOCCER_HUB then _G.SOCCER_HUB.running = false end
local S = { running = true }
_G.SOCCER_HUB = S

-------------------------------------------------- helpers
local function patch(keys, values)
	local entries = {}
	for _, e in ipairs(getgc(keys)) do
		if e.type == "number" then entries[#entries+1] = e end
	end
	pcall(applygc, entries, values)
end

-------------------------------------------------- feature patches
local function applyStamina()
	patch({ "DrainDuration", "RefillDuration", "JumpStaminaCost", "StaminaCost" },
	      { DrainDuration = 999999, RefillDuration = 0.1, JumpStaminaCost = 0, StaminaCost = 0 })
end

local function applyDodge()
	patch({ "CooldownSeconds", "RepeatDelaySeconds" },
	      { CooldownSeconds = 0, RepeatDelaySeconds = 0 })
end

local function applyGoalkeeper()
	patch({ "MaximumAssistDistance", "ZeroAssistMissStuds", "FullAssistMissStuds",
	        "MaximumExtraReachStuds", "MaximumVerticalVelocityChange",
	        "MaximumSaveHeight", "SaveWindowSeconds" },
	      { MaximumAssistDistance = 5000, ZeroAssistMissStuds = 500, FullAssistMissStuds = 500,
	        MaximumExtraReachStuds = 500, MaximumVerticalVelocityChange = 500,
	        MaximumSaveHeight = 500, SaveWindowSeconds = 5 })
end

local function applyAll()
	if CONFIG.UnlimitedStamina then applyStamina() end
	if CONFIG.NoDodgeCooldown  then applyDodge() end
	if CONFIG.AutoGoalkeeper   then applyGoalkeeper() end
end

-------------------------------------------------- run
applyAll()
print("[Soccer Hub] loaded (active until you leave):")
print("  Unlimited Stamina : " .. (CONFIG.UnlimitedStamina and "ON" or "off"))
print("  No Dodge Cooldown : " .. (CONFIG.NoDodgeCooldown  and "ON" or "off"))
print("  Auto Goalkeeper   : " .. (CONFIG.AutoGoalkeeper   and "ON" or "off"))

-- reassert in case the game re-seeds constants
task.spawn(function()
	while S.running and _G.SOCCER_HUB == S do
		task.wait(5)
		applyAll()
	end
end)
