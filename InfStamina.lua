-- ============================================================
--  SOCCER HUB · Inf Stamina  (JDUI front-end)
--  JDUI is a Matcha Drawing-based UI lib.
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

-------------------------------------------------- safe re-run
if _G.INF_UI then pcall(function() _G.INF_UI:Destroy() end) end

-------------------------------------------------- load JDUI
local ui = loadstring(game:HttpGet("https://raw.githubusercontent.com/jdev-studio/jdui/refs/heads/main/JDUI"))() or _G.JDUI
assert(ui and ui.AddTab, "JDUI failed to load")
_G.INF_UI = ui

ui:SetTitle("Soccer Hub")
ui:SetSubtitle("Unlimited Stamina")
pcall(function() ui:SetTheme("Green") end)
pcall(function() ui:SetKeybind(0xA1) end)       -- RightShift toggles the menu

-------------------------------------------------- stamina tab
local tab = ui:AddTab({ Title = "Stamina", Icon = "zap" })

local on = true
tab:AddToggle({
	Title       = "Unlimited Stamina",
	Description = "Drain ~0 · instant refill · free jumps",
	Default     = true,
	Callback    = function(v) on = v; apply(v) end,
})

tab:AddKeybind({
	Title       = "Quick toggle",
	Description = "Flip stamina on/off",
	Default     = 0x47, -- G
	Callback    = function() end,
})

tab:AddDivider("")

-- user-settable UNLOAD key (Delete by default)
local unloadBind = tab:AddKeybind({
	Title       = "Unload Key",
	Description = "Press this key to close the UI",
	Default     = 0x2E, -- Delete (VK)
})

tab:AddButton({
	Title       = "Unload now",
	Description = "Close the GUI (stamina patch stays).",
	ButtonText  = "Unload",
	Risk        = true,
	Callback    = function() pcall(function() ui:Destroy() end) end,
})

-------------------------------------------------- apply initial ON
apply(true)

-------------------------------------------------- unload-key watcher
-- armed only after the key has been released once (so rebinding it
-- in the UI doesn't instantly close the window).
task.spawn(function()
	local armed = false
	local lastVK = unloadBind.Value
	while _G.INF_UI == ui and ui.Alive do
		local vk = unloadBind.Value
		if vk ~= lastVK then armed = false; lastVK = vk end
		if vk and type(vk) == "number" then
			local down = iskeypressed(vk)
			if not down then armed = true
			elseif armed then
				pcall(function() ui:Destroy() end)
				break
			end
		end
		task.wait()
	end
end)

-- reassert stamina while UI alive
task.spawn(function()
	while _G.INF_UI == ui and ui.Alive do
		task.wait(5)
		if on then apply(true) end
	end
end)
