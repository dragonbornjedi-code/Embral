# EMBRAL — Agent Rules v2.0
# This file is read by ALL AI tools (Gemini CLI, Copilot, Cline, Claude Code, Windsurf, Kiro)
# before ANY action is taken in this repository.
# Last updated: 2026-04-20

---

## WHAT IS EMBRAL?

Embral is a local-first, open-source, neuroscience-backed educational RPG
for children ages 4–8. Single device. No internet required after install.
No cloud. No accounts. No subscriptions.

Built with Godot 4.5.x. MIT licensed. Public repo. Family-friendly.
Repo: https://github.com/dragonbornjedi-code/Embral
Local: /var/lib/phoenix-ai/workspace/embral/

---

## FIRST ACTIONS — DO THESE BEFORE ANYTHING ELSE

```
1. Read this file completely.
2. Read manifest.yaml completely.
3. Run: git log --oneline -10
4. Run: git status
5. Read docs/SESSION.md (last session summary)
6. State what you found.
7. Ask for the next task.
8. DO NOT write any code until steps 1-7 are complete.
```

---

## LAWS — VIOLATIONS BLOCK COMMIT

### LAW 1 — NO SECRETS IN CODE
Never write Tailscale IPs (100.x.x.x) in any file.
Never write API tokens, passwords, or keys in any file.
Never write real IP addresses in any committed file.
All external URLs loaded at runtime via secret-tool or config.
localhost (127.0.0.1) is the ONLY hardcoded address allowed.

### LAW 2 — NO INTELLECTUAL PROPERTY
No trademarked characters, franchises, or licensed IP in any file.
No Toei content (Dragon Ball, Shenron, etc.).
No DreamWorks content (Toothless, How to Train Your Dragon, etc.).
No Marvel, DC, Disney, Nintendo content.
No Nyan Cat, Doge, or trademarked meme properties.
No licensed music, sound effects, or artwork without explicit CC0/public domain license.
All assets must be original or explicitly CC0.

### LAW 3 — PERMANENTLY BANNED DEPENDENCIES
Embral is a single-device game. These are PERMANENTLY BANNED. Never add them.
- SQLite / godot-sqlite — Godot JSON + FileAccess handles all persistence
- ChromaDB — no vector stores
- Ollama — no AI inference at runtime
- Victoria / Amber — deprecated, do not reference
- Any RAG pipeline — no retrieval-augmented generation
- Any backend server — single device only
- Any cloud sync service

Violating this law with SQLite specifically caused a broken startup.
Removing godot-sqlite fixed the GDExtension load errors.

### LAW 4 — NO DUPLICATE FILES
Before creating any file, search the directory it belongs in.
If a file with that name or purpose already exists:
  → Edit the existing file. Do NOT create a new one.
  → NEVER create files named: *_fixed, *_clean, *_v2, *(1), *_working, *_old, *_backup
One canonical file per component. Period.

### LAW 5 — MANIFEST FIRST
Every new script, scene, data file, or asset must be registered in
manifest.yaml BEFORE it is created. If it is not in the manifest,
it does not belong in the repo.

### LAW 6 — HARDWARE EXPANDS, NEVER GATES
Base game (keyboard + mouse) must be 100% complete and playable.
Every hardware expansion (PS5, Wii, HA Green, Arduino, Pi, ESP32) adds
depth and immersion — it never locks content behind hardware ownership.
One documented exception: Summit Bonus Area in The Forge Run (sealed door
with lore note visible to base players — documented in roadmap).

### LAW 7 — CIRCUIT BREAKER ON ALL EXTERNAL CALLS
Every call to Home Assistant, ESP32, Arduino, or any network service
MUST check availability first and handle offline gracefully.
The game NEVER crashes or hangs due to missing hardware.
```gdscript
# Required pattern — no exceptions
if not HardwareManager.has_ha():
    return null  # caller handles null silently
```

### LAW 8 — QUESTS ARE HAND-AUTHORED
No quest content is procedurally generated or AI-generated at runtime.
Every quest lives in data/quests/{realm}/{quest_id}.json.
Required fields: quest_id, realm, npc_giver, research_basis,
developmental_target, age_range, steps, scaffolding.
Zero shortcuts. One developmental target per quest. Never two.

### LAW 9 — SINGLE FILE RESPONSIBILITIES
```
ha_bridge.gd        → ONLY file that calls Home Assistant
event_bus.gd        → ONLY file that broadcasts cross-system signals
hardware_manager.gd → ONLY file that detects hardware (cached at startup)
quest_manager.gd    → ONLY autoload managing quest state
save_manager.gd     → ONLY autoload managing persistence
```
Never duplicate these responsibilities into other files.

### LAW 10 — SAVE SYSTEM IS LOCAL ONLY
All saves go to user:// on the player's machine.
No cloud sync. No external backup service. No analytics.
Parent can manually backup user://save/ if desired.

### LAW 11 — SESSION LOG IS MANDATORY
At the END of every AI session, update docs/SESSION.md with:
- What was done this session
- What is currently broken
- What the next session should do first
- Which files were modified
This is the shared memory between AI sessions. Never skip it.

### LAW 12 — VERIFY BEFORE MARKING DONE
Status labels have exact meanings:
- DONE = runtime-verified or file-verified in headless Godot
- PARTIAL = exists but not fully verified
- STUB = placeholder only, no real implementation
- PLANNED = registered but not yet created
- DEFERRED = intentionally postponed with documented reason
- BROKEN = known issue requiring repair
Never mark DONE without actual verification.

---

## DIRECTORY LAW — WHERE FILES LIVE

```
data/quests/{realm}/        ← quest JSON files ONLY
data/npcs/                  ← NPC YAML definitions ONLY
data/dialogue/              ← fallback dialogue JSON ONLY
data/items/                 ← pet/wisp/item/reward definitions
data/wisps/                 ← wisp encounter definitions

scripts/autoloads/          ← ALL singleton autoloads
scripts/models/             ← ALL data classes (no game logic)
scripts/npcs/companions/    ← ONE .gd per companion. Nowhere else.
scripts/npcs/teachers/      ← ONE .gd per teacher NPC. Nowhere else.
scripts/player/             ← player_controller, party_manager
scripts/quest/              ← quest_loader, quest_runner, quest_reward
scripts/dungeon/            ← dungeon_manager, wisp_battle, crystal_system
scripts/hardware/           ← hardware_manager, ps5_input, wii_input,
                               esp32_client, pi_client, arduino_client
scripts/smart_home/         ← ha_bridge.gd ONLY
scripts/ui/                 ← all UI scripts
scripts/family/             ← family_raid_manager, mini_game_manager
scripts/minigames/          ← one script per mini-game

scenes/overworld/           ← 3D overworld scenes per realm
scenes/dungeons/            ← 2D platformer dungeon scenes
scenes/trials/              ← Embral's Trials scenes (one per realm)
scenes/ui/                  ← HUD, menus, parent dashboard
scenes/effects/             ← particles, celebrations, transitions

assets/models/              ← ONE copy per model. No duplicates.
assets/audio/               ← original audio ONLY. No licensed content.
assets/textures/
assets/fonts/
assets/portraits/

docs/                       ← docs ONLY. NO scripts in docs/.
addons/                     ← addons only. See plugins in manifest.yaml.
```

---

## REALM REFERENCE — USE THESE EXACTLY

| ID | Display Name | Domain | Wisp |
|----|-------------|--------|------|
| realm_0 | Hearthveil | Hub World | N/A |
| realm_1 | The Ember Hollow | SEL + Sensory Regulation | Ember (Fire) |
| realm_2 | The Tidemark | Literacy + Language | Ripple (Water) |
| realm_3 | The Forge Run | Physical Development | Breeze (Wind) |
| realm_4 | The Rootstead | Life Skills + Independence | Mossy (Earth) |
| realm_5 | The Spire | Science + Nature + Math | Volt (Electric) |
| realm_6 | The Drift | Creative Arts + Making | Lumis (Light) |
| dungeon_only | N/A | Dungeons only | Shade (Dark) |

Main NPC: **Ignavarr** — narrator, town mayor, dragon. Lives in Hearthveil.

---

## CREATURE SYSTEM REFERENCE

```
PETS      → Player's House ONLY. Mini-game. Passive bonuses. Never travel. Never battle.
WISPS     → Battle + puzzle. Element-based. 7 types. Up to 3 per character traveling.
            Slot 1 Wisp follows visibly in overworld. Player 3 + Companion 3 = max 6.
COMPANIONS → Second avatar. Player-named. Player-customized. One travels at a time.
             Co-op: second human player controls companion. Home capacity = 1 + floor(level/25).
```

---

## HARDWARE DETECTION PATTERN — ALWAYS THIS

```gdscript
# hardware_manager.gd detects ONCE at startup. Everything reads from it.
# No other script ever detects hardware directly.
if HardwareManager.has_ps5():    # adds haptic, motion, LED depth
if HardwareManager.has_wii():    # adds balance board, wiimote, IR depth
if HardwareManager.has_ha():     # adds smart home depth
if HardwareManager.has_esp32():  # adds gadget depth
if HardwareManager.has_arduino():
if HardwareManager.has_pi():
# Base game logic is NEVER inside a hardware if-block
```

---

## KEY SYSTEMS SUMMARY

**Embral's Trials** — One per realm. Hardware-powered milestone encounters.
Full base keyboard fallback always exists. Same rewards, different input.

**Nightly Review** — Parent + Ezra review portal. Ignavarr hosts. Parent taps
Raid Point orb when a meaningful moment happens. Max 1 per session.

**Weekend Family Raid** — Triggered at 3 Raid Points/week. Real-world family
activity framed as epic quest. 8 raid types. Failure Acceptance Raid specifically
celebrates collapse. Family Raid Shop exclusive to completions.

**NPC Mastery** — Per-NPC per-player. Last 5 quest scores averaged. ≥0.8 = level up.
Max level 5. Level 5 unlocks unique reward. This scales lesson difficulty individually.

**Mini-games** — Local only. 1-4 players. Earn Play Points. Academic games tied
to quest progress. Ezra vs AI companion is the default single-player mode.

---

## WHAT NEVER TO DO

- Never create `*_fixed`, `*_clean`, `*_v2`, `*(1)`, `*_working`, `*_old` files
- Never add SQLite, Ollama, ChromaDB, or any backend service
- Never import from imports/ or legacy/ directories into active scenes
- Never call Home Assistant except through ha_bridge.gd
- Never detect hardware except in hardware_manager.gd
- Never write hardcoded Tailscale IPs
- Never generate quest content with AI at runtime
- Never put GDScript files in docs/ folder
- Never commit node_modules/, .godot/imported/, or user:// directories
- Never install addons without registering them in manifest.yaml first
- Never mark a task DONE without runtime or file verification
- Never skip updating docs/SESSION.md at session end
