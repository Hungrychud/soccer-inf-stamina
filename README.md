# Soccer Hub · Unlimited Stamina

No UI. Run it and unlimited stamina turns **ON** and stays on until you leave the game.
Logs its status to the console.

Works by patching the Sprint module's `Constants` via `getgc`/`applygc`:
drain ≈ 0, instant refill, free jumps, zero costs.

## Loadstring

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Hungrychud/soccer-inf-stamina/main/InfStamina.lua"))()
```

Console prints:

```
[Inf Stamina] ON - unlimited stamina active (until you leave)
```

> Educational / personal use. Game-specific; constant values are tuned for one place.
> Re-run or rejoin to re-apply. Matcha caches `httpget` per session — rejoin to pull updates.
