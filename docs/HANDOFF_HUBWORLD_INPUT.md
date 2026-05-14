# Handoff — HubWorld playable entry, portals, input, and cleanup

**Project root:** `/var/lib/phoenix-ai/workspace/embral`  
**Godot:** 4.6.2 stable (`godot --version` → `4.6.2.stable.official.71f334935`)

## Current status

The original repair notes below are still mostly true, but the scene has moved beyond load-only greybox.

Implemented and runtime-verified:

- **`HubWorld.tscn` loads** with no parse/load/script errors.
- **Main menu profile flow**: boot → main menu → select completed profile → `HubWorld.tscn`; create new or select unfinished profile → `Main.tscn` tutorial.
- **Interact press handling** dispatches `interact` on the current `interact_target` and calls `get_viewport().set_input_as_handled()`.
- **Tutorial MVP route exists**: controls + Ignavarr intro, portal/dungeon tour, one starter guide quest in each realm, return to Ignavarr, unlock house, level 2, and first pet.
- **Save rewards persist**: `SaveManager` listens for `gold_gained` / `xp_gained`, updates the active local profile, and saves to `user://`.
- **Six realm portals are visible** in Hearthveil and point to existing realm scenes.
- **Real model assets are now instanced** in the hub: generic dragon, fantasy tower, medieval buildings, owl guide, and portal crystals.
- **Copyright cleanup**: trademarked collectible content was replaced with original `EmberSigil`; unused style-referenced baby dragon asset files were removed.

## Smoke checks

No `Parse Error`, `Failed loading resource`, or `SCRIPT ERROR` should appear. Godot quick-quit shutdown “resources still in use” noise is still expected.

```bash
godot --headless --path /var/lib/phoenix-ai/workspace/embral --quit-after 5
godot --headless --path /var/lib/phoenix-ai/workspace/embral \
  res://scenes/overworld/hearthveil/HubWorld.tscn --quit-after 5
```

## Entry flow

- **Boot:** `res://scenes/boot.tscn` → main menu.
- **Profile selected:** `scripts/ui/main_menu.gd` routes incomplete profiles to `res://scenes/overworld/Main.tscn` and completed profiles to `res://scenes/overworld/hearthveil/HubWorld.tscn`.
- **Avatar completed:** `scripts/ui/AvatarCreator.gd` routes new profiles to `res://scenes/overworld/Main.tscn`.

## Key files

| Area | Path |
|------|------|
| Hub root script | `scripts/world/HubWorldManager.gd` |
| Hub scene | `scenes/overworld/hearthveil/HubWorld.tscn` |
| World env helper | `scripts/world/WorldEnvironment.gd` |
| Weather stub | `scripts/world/WeatherSystem.gd` |
| Player interact + handled | `scripts/player/player_controller.gd` |
| NPC interact meta | `scripts/npcs/base_npc.gd` (sets `interact_target` on player body) |
| Hub first-step logic | `scripts/world/HubWorldManager.gd` |
| Tutorial manager | `scripts/world/tutorial_manager.gd` |
| Tutorial quest data | `data/quests/hearthveil/hv_ignavarr_tutorial_01.json` |
| Tutorial realm quests | `EH_EMO_001`, `TM_LET_001`, `FR_BAL_001`, `RS_CHO_001`, `SP_NUM_001`, `DR_ART_001` |
| HUD objective | `scenes/ui/PlayerHUD.tscn`, `scripts/ui/PlayerHUD.gd` |
| Reward persistence | `scripts/autoloads/save_manager.gd` |
| Realm portals | `scripts/ui/portal_marker.gd`, nodes under `RealmPortals` in `HubWorld.tscn` |
| Hub UI stubs / shells | `QuestUI.gd`, `QuestCompleteDialog.gd`, `MobileControls.gd`, `VirtualJoystick.gd`, `ParentDashboard.gd`, `DailyProgressTracker.gd`, `QuestTimer.gd`, `AchievementPopup.gd` |
| Shop | `scripts/shop/ShopUI.gd` — `open()` / `close()` |
| NPC scripts (paths expected by scenes) | `scripts/npc/QuestGiver.gd`, `scripts/npc/Shopkeeper.gd` |
| Collectibles | `scenes/entities/Coin.tscn`, `scenes/entities/EmberSigil.tscn` + `scripts/world/ember_sigil.gd` |
| Mobile shapes fix | `scenes/ui/MobileControls.tscn` — `CircleShape2D` sub-resources added |
| Controller input maps | `project.godot` `[input]` (`ui_left/right/up/down`, `interact`) |

## Realm portals

All six portal targets exist on disk:

- `ember_hollow` → `scenes/overworld/ember_hollow/ember_hollow.tscn`
- `tidemark` → `scenes/overworld/tidemark/tidemark.tscn`
- `forge_run` → `scenes/overworld/forge_run/forge_run.tscn`
- `rootstead` → `scenes/overworld/rootstead/rootstead.tscn`
- `the_spire` → `scenes/overworld/the_spire/the_spire.tscn`
- `the_drift` → `scenes/overworld/the_drift/the_drift.tscn`

The portals are currently unlocked for traversal so base keyboard/mouse players can inspect progress. Later progression gating should be explicit and must not block base input players behind optional hardware.

## Input / hardware truth

- Keyboard/mouse: **works** for movement and interact.
- Generic/PS5-style controller: movement/interact mappings are present in `project.godot`; OS-level Bluetooth pairing still has to expose the controller to Godot as a joypad.
- PS5 haptics: partially wired in `scripts/hardware/ps5_input.gd`.
- Wii remote: `HardwareManager` can detect Wii-family devices from Linux input text, but gameplay input is **not fully wired** unless the OS exposes the device as a standard joypad. Treat Wii as PARTIAL, not DONE.

## HubWorld path corrections (reference)

- `scenes/npc/*` → **`scenes/npcs/*`** (`QuestGiverBase`, `Shopkeeper`)
- `scenes/shop/ShopUI.tscn` → **`scenes/ui/ShopUI.tscn`**
- `scenes/world/Coin.tscn` → **`scenes/entities/Coin.tscn`**
- `scenes/world/EmberSigil.tscn` → **`scenes/entities/EmberSigil.tscn`**
- `scenes/ui/QuestCompleteDialog.tscn` → **`scenes/effects/QuestCompleteDialog.tscn`**

## Important caveats for the next owner

- Several hub-adjacent scripts are still **stubs/shells**. The world now has a first objective and portals, but shop inventory, quest panel wiring, mobile joystick routing, parent PIN policy, and full NPC quest behavior still need real product implementation.
- The tutorial MVP route is runtime-verified, but do not claim 21 quests per realm exist. Current repo content has 8 authored quests per realm and the tutorial uses one starter quest per realm.
- **`QuestCompleteDialog`**: confirm button emits `EventBus.quest_completed` only — there is **no** `QuestManager.complete_quest()` in this repo; wire to real completion logic when defined.
- **`ParentDashboard.gd`** (hub scene variant): simplified PIN flow vs `scripts/ui/parent_dashboard.gd` used elsewhere — reconcile if you need one canonical implementation.
- **Visual quality**: real assets are now present, but many buildings/NPCs remain greybox/simple shapes. This is playable scaffolding, not final art direction.
- If Dialogic still steals keys in edge cases, consider **`set_input_as_handled()`** in additional listeners or tightening Dialogic input action overlap with `interact`.

## Suggested next increments

1. Replace hub greybox buildings/NPCs with approved original/CC0 model instances.
2. Implement real portal arrival/spawn positions in each realm.
3. Replace stub UI/NPC behavior with real `QuestManager` + Dialogic timelines per NPC id.
4. Unify `PlayerHUD.tscn` (`PlayerHUD.gd`) vs `player_hud.tscn` (`player_hud.gd`) if both remain long-term.
5. Complete OS/Godot controller verification for PS5 and Wii-family hardware before marking hardware input DONE.
