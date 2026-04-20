# EMBRAL — Agent Rules v1.0
# This file is read by ALL AI tools (Gemini CLI, Copilot, Cline, Claude Code)
# before ANY action is taken in this repository.
# Last updated: 2026-04-19

---

## WHAT IS EMBRAL?

Embral is a local-first, open-source, neuroscience-backed educational RPG
for children ages 4–8. It is a single-device game. It runs on one machine.
No cloud. No accounts. No subscriptions. No internet required after install.

Built with Godot 4. MIT licensed. Public repo. Family-friendly.

---

## LAWS — VIOLATIONS BLOCK COMMIT

### LAW 1 — NO SECRETS IN CODE
Never write Tailscale IPs (100.x.x.x) in any file.
Never write API tokens, passwords, or keys in any file.
Never write real IP addresses in any committed file.
All external URLs use environment variables or secret-tool at runtime.
localhost (127.0.0.1) is the ONLY hardcoded address allowed.

### LAW 2 — NO INTELLECTUAL PROPERTY
No trademarked characters, franchises, or IP in any file.
No Toei content (Dragon Ball, Shenron, etc.).
No DreamWorks content (Toothless, How to Train Your Dragon, etc.).
No Marvel, DC, Disney, Nintendo content.
No Nyan Cat, Doge, or other trademarked meme properties.
No licensed music, sound effects, or artwork.
All assets must be original or explicitly CC0/public domain.

### LAW 3 — NO RAG, NO BACKEND AI, NO VECTOR STORES
Embral is a single-device game. There is no:
- ChromaDB
- Ollama
- Victoria
- Amber
- Any RAG pipeline
- Any AI generation at runtime
All quest content is hand-authored JSON. No procedural generation.

### LAW 4 — NO DUPLICATE FILES
Before creating any file, check the directory it belongs in.
If a file with that name or purpose already exists anywhere in the repo:
  → Edit the existing file. Do NOT create a new one.
  → Do NOT create files named *_fixed, *_clean, *_v2, *(1), *_working.
One canonical file per component. Period.

### LAW 5 — MANIFEST FIRST
Every new script, scene, data file, or asset must be registered in
manifest.yaml BEFORE it is created. If it is not in the manifest,
it does not belong in the repo.

### LAW 6 — HARDWARE EXPANDS, NEVER GATES
Base game (keyboard + mouse) must be 100% complete.
Every hardware expansion (PS5, Wii, HA, Arduino, Pi, ESP32) adds
depth and immersion — it never locks content behind hardware.
Exception: The Summit Bonus Area in The Forge Run (documented exception).

### LAW 7 — CIRCUIT BREAKER ON ALL EXTERNAL CALLS
Every call to Home Assistant, ESP32, Arduino, or any network service
MUST check availability first and handle offline gracefully.
The game must never crash or hang due to a missing hardware expansion.
Pattern:
  if not hardware_manager.has_ha(): return null
  # caller handles null silently, game continues

### LAW 8 — QUESTS ARE HAND-AUTHORED
No quest content is procedurally generated or AI-generated at runtime.
Every quest lives in data/quests/{realm}/{quest_id}.json.
Every quest has: research_basis, developmental_target, age_range, steps,
scaffolding, npc_giver.
Zero shortcuts.

### LAW 9 — SINGLE FILE RESPONSIBILITIES
ha_bridge.gd     → ONLY file that communicates with Home Assistant
event_bus.gd     → ONLY file that broadcasts cross-system signals
hardware_manager.gd → ONLY file that detects hardware, results cached at startup
quest_manager.gd → ONLY autoload managing quest state
Never duplicate these responsibilities into other files.

### LAW 10 — SAVE SYSTEM IS LOCAL ONLY
All saves go to user:// directory on the player's machine.
No cloud sync. No external backup service. No analytics.
Parent can manually backup user://save/ if desired.

---

## DIRECTORY LAW — WHERE FILES LIVE

```
data/quests/{realm}/          ← quest JSON files ONLY
data/npcs/                    ← npc YAML definitions ONLY
data/dialogue/                ← fallback dialogue JSON ONLY
data/items/                   ← pet/wisp/item definitions ONLY
data/wisps/                   ← wisp encounter definitions ONLY

scripts/autoloads/            ← ALL singleton autoloads
scripts/models/               ← ALL data classes (no game logic)
scripts/npcs/companions/      ← ONE .gd per companion. Nowhere else.
scripts/npcs/teachers/        ← ONE .gd per teacher NPC. Nowhere else.
scripts/player/               ← player_controller, party_manager
scripts/quest/                ← quest_loader, quest_runner, quest_reward
scripts/dungeon/              ← dungeon_manager, wisp_battle, crystal_system
scripts/hardware/             ← hardware_manager, ps5_input, wii_input,
                                 esp32_client, pi_client, arduino_client
scripts/smart_home/           ← ha_bridge.gd ONLY
scripts/ui/                   ← all UI scripts

scenes/overworld/             ← 3D overworld scenes per realm
scenes/dungeons/              ← 2D platformer dungeon scenes (one per realm)
scenes/ui/                    ← HUD, menus, parent dashboard

assets/models/                ← ONE copy per model. No duplicates.
assets/audio/                 ← original audio ONLY
assets/textures/
assets/fonts/
assets/portraits/
```

---

## REALM NAMES — USE THESE EXACTLY

| ID | Name | Domain | Wisp |
|----|------|--------|------|
| realm_0 | Hearthveil | Hub World | N/A |
| realm_1 | The Ember Hollow | SEL + Sensory Regulation | Ember (Fire) |
| realm_2 | The Tidemark | Literacy + Language | Ripple (Water) |
| realm_3 | The Forge Run | Physical Development | Breeze (Wind) |
| realm_4 | The Rootstead | Life Skills + Independence | Mossy (Earth) |
| realm_5 | The Spire | Science + Nature + Math | Volt (Electric) |
| realm_6 | The Drift | Creative Arts + Making | Lumis (Light) |
| dungeon_only | N/A | Dungeons only | Shade (Dark) |

---

## CREATURE SYSTEM — THREE TYPES, NEVER CONFUSED

PETS     → Stay at player's house. Interactive mini-game only.
           Passive bonus to main game based on happiness level.
           Max at home: 20. No battles. No travel.

WISPS    → Battle + puzzle helpers. Element-based. 7 types.
           Up to 3 per character traveling at a time.
           Slot 1 Wisp follows player visibly in overworld.
           Player has 3, Companion has 3. Total in world: 2 visible (slot 1s).

COMPANIONS → Second avatar. Player-named and customized.
             One travels at a time. Others wait at home.
             Home capacity: starts at 1, +1 per 25 player levels.
             Fully switchable. Co-op: second player controls companion.

---

## PROGRESSION SYSTEM

PLAYER LEVEL:
  Unlocks at specific levels (not all listed — see manifest.yaml):
  Level 1  → Tutorial complete, Hearthveil unlocked
  Level 5  → Wisps unlocked
  Level 10 → Companions unlocked
  Level 25 → Ground mounts unlocked. +1 companion home slot.
  Level 50 → Companion home slot +1. New game features unlock.
  Level 75 → Companion home slot +1. New game features unlock.
  Level 100 → Ascension milestone. New content layer unlocks.
  Every 25 levels → +1 companion home slot.

NPC MASTERY LEVEL (per NPC, per player):
  Tracks average score across all quests for that NPC.
  High enough average → unlocks next difficulty tier for that NPC's quests.
  Mastery level is separate from player level.
  This is how lesson difficulty scales — per NPC, not globally.

DUNGEON UNLOCK: 3 NPCs discovered per realm (except Hearthveil).
FLYING MOUNTS: Ascension milestone (level 100).

---

## HARDWARE EXPANSIONS — DETECTION PATTERN

Always follow this pattern. No exceptions.
```gdscript
# hardware_manager.gd handles ALL detection at startup
# Other scripts ONLY read from hardware_manager — never detect themselves
if HardwareManager.has_ps5():
    # add ps5 depth
if HardwareManager.has_wii():
    # add wii depth
if HardwareManager.has_ha():
    # add smart home depth
if HardwareManager.has_esp32():
    # add gadget depth
if HardwareManager.has_arduino():
    # add arduino depth
if HardwareManager.has_pi():
    # add raspberry pi depth
# Base game path never inside any hardware if-block
```

---

## WHAT TO DO IF YOU ARE UNCERTAIN

1. Check manifest.yaml — if the component isn't registered, register it first.
2. Check data/npcs/ — if the NPC doesn't exist, don't invent one.
3. Check scripts/autoloads/ — use existing singletons, don't create new ones.
4. If a file already exists that does what you need — EDIT IT, don't make a new one.
5. When in doubt, ask for clarification before creating anything.

## WHAT NEVER TO DO

- Never create a file with _fixed, _clean, _v2, *(1), _working in the name.
- Never import from the imports/ or legacy/ directories into active scenes.
- Never call Home Assistant from any script except ha_bridge.gd.
- Never write hardcoded Tailscale IPs.
- Never generate quest content with AI at runtime.
- Never put scripts in the docs/ folder.
- Never commit node_modules/, .godot/imported/, or user:// directories.
