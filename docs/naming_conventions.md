# Embral — Naming Conventions

> **Authority:** These conventions are binding for all scripts, scenes, data files,
> and assets. When in doubt, check this file. If this file conflicts with
> `AGENTS.md`, `AGENTS.md` wins (it contains hard Laws).

---

## Realms

Use the exact IDs from `AGENTS.md`. No variations.

| ID | Display Name | Directory slug |
|----|-------------|----------------|
| `realm_0` | Hearthveil | `hearthveil` |
| `realm_1` | The Ember Hollow | `ember_hollow` |
| `realm_2` | The Tidemark | `tidemark` |
| `realm_3` | The Forge Run | `forge_run` |
| `realm_4` | The Rootstead | `rootstead` |
| `realm_5` | The Spire | `the_spire` |
| `realm_6` | The Drift | `the_drift` |

**Rules:**
- Realm IDs in code: `"realm_0"`, `"realm_1"`, etc. (snake_case string)
- Directory slugs: lowercase, underscores, no "the_" prefix except where shown above
- Signal payloads use the realm ID string: `EventBus.player_entered_realm.emit("realm_1")`

---

## NPCs

**File naming:** `scripts/npcs/teachers/{npc_id}.gd`
**Data file:** `data/npcs/{npc_id}.yaml`

**NPC ID format:** `lowercase_snake_case` — e.g., `ignavarr`, `mossy_keeper`

**Rules:**
- One `.gd` file per NPC. No duplicates.
- NPC IDs must match between the script filename, the YAML key, and all quest JSON references.
- Never invent an NPC ID that isn't in `data/npcs/`. Check first.

---

## Quests

**File naming:** `data/quests/{realm_slug}/{quest_id}.json`

**Quest ID format:** `{realm_slug}_{npc_id}_{descriptor}_{sequence_number}`
- Example: `ember_hollow_ignavarr_big_feelings_01`
- Sequence numbers are zero-padded two digits: `01`, `02`, `10`

**Required JSON fields** (from AGENTS.md Law 8):
```
quest_id, research_basis, developmental_target, age_range,
steps, scaffolding, npc_giver, completion_reward
```

---

## GDScript Files

| Type | Convention | Example |
|------|-----------|---------|
| Autoloads | `snake_case.gd` | `save_manager.gd` |
| Data models | `snake_case_data.gd` | `wisp_data.gd` |
| Controllers | `snake_case_controller.gd` | `player_controller.gd` |
| NPC scripts | `{npc_id}.gd` | `ignavarr.gd` |
| UI scripts | `snake_case_ui.gd` or `snake_case_panel.gd` | `hud_ui.gd` |

**Variable naming:**
- Private: `_snake_case` (leading underscore)
- Public: `snake_case`
- Constants: `ALL_CAPS_SNAKE`
- Signals: `past_tense_verb` — e.g., `quest_completed`, `npc_discovered`
- Type hints: always required on function signatures

---

## Scenes

**File naming:** `snake_case.tscn`

| Scene type | Directory | Example |
|-----------|-----------|---------|
| Overworld realm | `scenes/overworld/{realm_slug}/` | `scenes/overworld/hearthveil/hearthveil.tscn` |
| Dungeon | `scenes/dungeons/` | `scenes/dungeons/mirror_maze.tscn` |
| UI | `scenes/ui/` | `scenes/ui/main_menu.tscn` |
| Effects | `scenes/effects/` | `scenes/effects/wisp_capture.tscn` |

**Root node naming:** PascalCase matching the scene purpose — e.g., `MainMenu`, `Hearthveil`, `MirrorMaze`

---

## Data Files

| Type | Format | Directory | Naming |
|------|--------|-----------|--------|
| Quests | JSON | `data/quests/{realm_slug}/` | `{quest_id}.json` |
| NPCs | YAML | `data/npcs/` | `{npc_id}.yaml` |
| Dialogue fallbacks | JSON | `data/dialogue/` | `{npc_id}_fallback.json` |
| Items | JSON | `data/items/` | `{item_id}.json` |
| Wisps | JSON | `data/wisps/` | `{wisp_type}.json` |

---

## Assets

- Models: `assets/models/{category}/{name}.glb` or `.tres`
- Textures: `assets/textures/{category}/{name}.png`
- Audio: `assets/audio/{category}/{name}.ogg`
- Fonts: `assets/fonts/{name}.ttf`
- Portraits: `assets/portraits/{npc_id}.png`

**Rules:**
- One canonical copy per asset. No `_v2`, `_fixed`, `_copy` variants (Law 4).
- All audio must be original or CC0 (Law 2).

---

## Save Files

All saves go to `user://` (Law 10). Paths from `manifest.yaml`:

| Key | Path |
|-----|------|
| Player profile | `user://save/player_profile.json` |
| World state | `user://save/world_state.json` |
| Pet roster | `user://save/pet_roster.json` |
| Wisp roster | `user://save/wisp_roster.json` |
| Party | `user://save/party.json` |
| NPC mastery | `user://save/npc_mastery.json` |
| Parent data | `user://save/parent_dashboard.json` |
| Config | `user://config.json` |

> **Note:** `SaveManager` currently uses `user://save_game.json` — this is a known
> inconsistency to be resolved in Phase 1.04 when save paths are unified.

---

## Git Tags

Format: `v{phase}-{descriptor}` — e.g., `v0.00-foundation-pre-work`, `v1.00-safety-complete`
