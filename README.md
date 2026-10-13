# Soccer Hub · Unlimited Stamina

Matcha Drawing-based GUI (uses the **INS-ui** library, same one BetterVoid uses) that
gives **unlimited stamina** by patching the Sprint module's `Constants` via
`getgc`/`applygc` — drain ≈ 0, instant refill, free jumps.

## Loadstring

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Hungrychud/soccer-inf-stamina/main/InfStamina.lua"))()
```

## Controls

- **P** — open / close the menu
- **Unlimited Stamina** toggle — ON by default
- **G** — quick on/off (toggle keybind, rebindable in-UI)
- **Unload** button — closes the GUI
- Drag the window by its header

## How it works

Matcha's VM can't render Roblox `ScreenGui`, so the UI uses the **Drawing** library
([INS-ui](https://github.com/neaxusxgod-png/INS-ui)). The stamina effect edits the live
`DrainDuration` / `RefillDuration` / `JumpStaminaCost` / `StaminaCost` number constants
in the running game via `getgc({...})` + `applygc(...)`. Toggle OFF restores the originals.

> Educational / personal use. Game-specific; constant values are tuned for one place.
