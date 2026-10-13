# Soccer Hub · Unlimited Stamina

Drawing-based GUI (for executors with the Matcha `Drawing` API) that gives
**unlimited stamina** by patching the Sprint module's `Constants` via `getgc`/`applygc`
— drain ≈ 0, instant refill, free jumps.

## Loadstring

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Hungrychud/soccer-inf-stamina/main/InfStamina.lua"))()
```

## Controls

- **RightShift** — show / hide the menu
- **Unlimited Stamina** toggle — ON by default
- **Quick toggle** (`G`) — flip stamina on/off
- **Unload Key** (`Delete`) or the **Unload** button — closes the GUI (patch stays)
- All keybinds rebindable in the UI (click the bind, press a new key)
- Drag the window by its header

## How it works

Matcha's VM can't render Roblox `ScreenGui`, so the UI uses the **Drawing** library
([JDUI](https://github.com/jdev-studio/jdui)). The stamina effect edits the live
`DrainDuration` / `RefillDuration` / `JumpStaminaCost` / `StaminaCost` number constants
in the running game via `getgc({...})` + `applygc(...)`. Toggle OFF restores the originals.

> Educational / personal use. Game-specific; constant values are tuned for one place.
