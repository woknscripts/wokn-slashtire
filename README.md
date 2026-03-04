# wokn-slashtire

A FiveM ESX script that allows players to slash vehicle tires using sharp weapon items from `ox_inventory`.

## Dependencies

| Resource | Link |
|---|---|
| `es_extended` | ESX Framework |
| `ox_lib` | https://github.com/overextended/ox_lib |
| `ox_target` | https://github.com/overextended/ox_target |
| `ox_inventory` | https://github.com/overextended/ox_inventory |

## Installation

1. Drop the `wokn-slashtire` folder into your `resources` directory.
2. Add `ensure wokn-slashtire` to your `server.cfg` **after** ESX, ox_lib, ox_target, and ox_inventory.
3. Configure `config.lua` to match your sharp weapon item names in ox_inventory.

## Configuration (`config.lua`)

```lua

| Option | Default | Description |
|---|---|---|
| `Config.SharpWeapons` | See above | ox_inventory item names that allow tire slashing |
| `Config.ProgressDuration` | `4000` | Progress bar duration in milliseconds |
| `Config.Cooldown` | `3000` | Cooldown between slashes in milliseconds |
| `Config.TargetLabel` | `'Slash Tire'` | ox_target option label |
| `Config.TargetIcon` | `'fas fa-knife'` | ox_target option icon (Font Awesome) |
| `Config.Debug` | `false` | Enable debug prints |

## How It Works

1. Player approaches any vehicle.
2. `ox_target` shows the **Slash Tire** option when hovering over the vehicle.
3. If the player has a valid sharp weapon item in their `ox_inventory`, the interaction begins.
4. A crouching animation plays alongside an `ox_lib` progress bar.
5. On completion, a tire pop sound plays and the closest tire to the player bursts.
6. The server validates the item server-side before broadcasting the tire burst to all clients.

## Notes

- Occupied vehicles cannot be targeted.
- The script automatically detects the closest tire to the player on the vehicle.
- Server-side validation prevents exploiting/cheating.
