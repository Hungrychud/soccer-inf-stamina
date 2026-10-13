-- ============================================================
--  SOCCER HUB · Inf Stamina  (no UI, console only)
--  On execute: unlimited stamina ON, stays on until you leave.
--  Patches Sprint Constants via getgc/applygc:
--    drain ~0 · instant refill · free jumps · zero costs.
-- ============================================================

local KEYS = { "DrainDuration", "RefillDuration", "JumpStaminaCost", "StaminaCost" }
local HACKED = { DrainDuration = 999999, RefillDuration = 0.1, JumpStaminaCost = 0, StaminaCost = 0 }

local function numericEntries()
	local nums = {}
	for _, e in ipairs(getgc(KEYS)) do
		if e.type == "number" then table.insert(nums, e) end
	end
	return nums
end

local function applyStamina()
	pcall(applygc, numericEntries(), HACKED)
end

-- stop any previous run's loop
if _G.INF_STAM then _G.INF_STAM.running = false end
local S = { running = true }
_G.INF_STAM = S

applyStamina()
print("[Inf Stamina] ON - unlimited stamina active (until you leave)")

-- reassert periodically in case the module re-seeds its constants
task.spawn(function()
	while S.running and _G.INF_STAM == S do
		task.wait(5)
		applyStamina()
	end
end)
