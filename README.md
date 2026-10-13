# Soccer Hub

No-UI cheat scripts for a Roblox soccer game. Run → features turn **ON** and stay on
until you leave. Status is logged to the console. Everything works by patching live
game `Constants` via Matcha's `getgc`/`applygc` (no Drawing UI, so it won't crash Matcha).

## Soccer Hub (all features)

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Hungrychud/soccer-inf-stamina/main/SoccerHub.lua"))()
```

Features (edit the `CONFIG` flags at the top to toggle):

- **Unlimited Stamina** — drain ≈ 0, instant refill, free jumps
- **No Dodge Cooldown** — dash/dodge with no cooldown
- **Auto Goalkeeper** — superhuman dive assist (perfect saves)

Console prints:

```
[Soccer Hub] loaded (active until you leave):
  Unlimited Stamina : ON
  No Dodge Cooldown : ON
  Auto Goalkeeper   : ON
```

## Unlimited Stamina only

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Hungrychud/soccer-inf-stamina/main/InfStamina.lua"))()
```

## Notes

- Educational / personal use. Game-specific; constant values are tuned for one place.
- Re-run or rejoin to re-apply. Matcha caches `httpget` per session — rejoin (or add
  `?v=`..os.time() to the URL) to pull updates.
