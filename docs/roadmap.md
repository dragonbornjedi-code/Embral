# Embral Project Roadmap (Resilience-First)

> **Living Document.** Every step must be completed, tested, and verified before marking DONE.
> Status labels: DONE | PARTIAL | STUB | PLANNED | DEFERRED | BROKEN

**Current Phase:** 3.00 NPC System
**Godot Version:** 4.5.stable.official.876b29033
**Last Sync:** 2026-04-23
**Repo:** https://github.com/dragonbornjedi-code/Embral

---

## STATUS KEY
- `[x]` = DONE — runtime or file verified
- `[~]` = PARTIAL — exists but not fully complete
- `[ ]` = PLANNED — not started
- `[!]` = BROKEN — known issue, needs repair
- `[-]` = DEFERRED — intentionally postponed

---

## 0.00 Foundation
- [x] **0.01** Record verified Godot 4.5.x runtime build. `4.5.stable.official.876b29033`
- [x] **0.02** Create Git backup and restore point. Tagged `embral-foundation-snapshot`.
- [x] **0.03** Define source-of-truth hierarchy: Runtime Logs > Disk > Docs > Model assumptions.
- [x] **0.04** Create `docs/compatibility.md` for pinned dependency versions.
- [x] **0.05** Create minimal boot scene `scenes/boot.tscn` with health check sequence.
- [x] **0.06** Finalize `EventBus` with all signals: quest, UI, realm, hardware, creatures.
- [x] **0.07** Establish naming conventions. All realm, NPC, quest names locked in `AGENTS.md`.
- [x] **0.08** `test_sandbox.tscn` and `test_house.tscn` verified: floor mesh + house instance loads cleanly in headless.
- [x] **0.09** `AGENTS.md` v2.0 committed. All AI tools read it before acting.
- [x] **0.10** `manifest.yaml` v2.0 committed. All components registered.
- [x] **0.11** `docs/SESSION.md` established. AI session handoff protocol in place.
- [x] **0.12** Shell alias system installed (`~/.embral_aliases.sh`). All AI tools auto-load context on launch.
- [x] **0.13** `.cursorrules` committed for Windsurf/Cursor compliance.
- [x] **0.14** `docs/AI_CONTEXT.md` maintained as master context prompt for all AI CLIs.

---

## 1.00 Safety / Integrity
- [x] **1.01** LimboAI v1.6.0 runtime-verified. `BehaviorTree`, `LimboState`, `LimboHSM` registered.
- [x] **1.02** ~~SQLite binding~~ — **REMOVED.** godot-sqlite was added by Windsurf without authorization. Embral uses Godot JSON + FileAccess. Removing it fixed GDExtension startup errors. Do not re-add. Verified clean boot.
- [x] **1.03** Dialogic 2 v2.0-Alpha-19 on disk, enabled, runtime-verified. `dialogic_stub.gd` launches real timelines or falls back to JSON.
- [x] **1.04** `SaveManager` schema v1 with v0 migration. Unknown versions quarantined.
- [x] **1.05** Quest JSON validation: 8 required fields checked on load. Missing fields logged and rejected.
- [x] **1.06** Content quarantine: invalid quest files logged with reason and not loaded.
- [x] **1.07** Fallback dialogue: `dialogic_stub.gd` returns fallback line when Dialogic missing.
- [x] **1.08** HA Safe Mode: `ha_bridge._safe_mode` reads from config. All HA methods guarded.
- [x] **1.09** LimboAI `addons/demo/` folder **REMOVED.** It caused preload errors (res://demo/... paths). LimboAI itself untouched. Verified via git rm.
- [x] **1.10** Boot root changed from `Node2D` to `Node`. Scene transition deferred. Headless boot clean.
- [ ] **1.11** Verify `dialogic_stub.gd` actually launches a real Dialogic timeline end-to-end with a test NPC. Timeline integration pending — mark DONE only after live test.
- [x] **1.12** Verify `save_manager.gd` write/read cycle in headless. (Verified in current session)
- [x] **1.13** Verify `quest_manager.gd` loads a sample quest JSON, validates all 8 fields, and emits `quest_started` signal in headless test.
- [x] **1.14** Add `docs/SESSION.md` update to the end of every CI/AI session as enforced habit. Verify it was updated in last 3 sessions.

---

## 2.00 Reliability / Core Systems
> Goal: Core game systems functional. Player can walk around Hearthveil, talk to Ignavarr, and receive a quest.

- [x] **2.01** Fix main menu scene: `scenes/ui/main_menu.tscn` loaded/rebuilt. Fixed @onready errors. Verified clean headless boot.
- [x] **2.02** Main menu displays: Profile list, New Game, Continue, Settings, Parent Dashboard (PIN-gated). No art needed — white-box UI.
- [x] **2.03** Profile system: create, select, and delete player profiles. Each profile has its own `user://save/{profile_id}/` directory.
- [x] **2.04** Implement `PlayerProfile` data class: level, XP, gold, quest_completion dict.
- [x] **2.05** Implement `PartyManager` stub.
- [x] **2.06** Implement `PlayerController`: keyboard/mouse movement, camera follow, interact button. Reads from `HardwareManager` only.
- [x] **2.07** Hearthveil white-box scene: flat plane, Ignavarr spawn point, Player spawn.
- [x] **2.08** Ignavarr NPC script: proximity detection, interact trigger, dialogue launch via `dialogic_stub.gd`.
- [x] **2.09** Tutorial sequence: Ignavarr interaction and tutorial coin collection.
- [x] **2.10** Player's House stub.
- [x] **2.11** Hearthveil portal markers stubbed in Main.tscn.
- [x] **2.12** `QuestManager` end-to-end test: verified loading and emission.
- [x] **2.13** `SaveManager` end-to-end test: verified self-healing file access.
- [x] **2.14** HUD scene: XP bar, gold counter, active quest name. No art needed.
- [x] **2.15** Emotional check-in: pop-up at game start and every 30 minutes. Logs to `user://save/parent_dashboard.json`.
- [x] **2.16** Settings menu: volume sliders, fullscreen toggle, hardware expansion enables/disables.
- [x] **2.17** Parent dashboard: PIN entry screen, emotional check-in history list.
- [x] **2.18** Simple follow camera implemented in PlayerController (lerp-based).
- [x] **2.19** Scene transition system: TransitionManager with fade-out/fade-in sequence.
- [x] **2.20** Verify entire flow headless: boot → main menu → profile select → hearthveil → interaction → verified OK.

---

## 3.00 NPC System / Quest Content Foundation
> Goal: Each realm has 4 starter NPCs. Each starter NPC has 2 verified quests. Tutorial complete.

- [ ] **3.01** Implement `BaseNPC`: proximity Area3D, interact signal, dialogue dispatch, NPC state machine (idle/talking/giving_quest/completed).
- [ ] **3.02** Implement `BaseTeacherNPC` extending `BaseNPC`: quest catalogue lookup, mastery level read, available quest filtering by age range and prerequisites.
- [ ] **3.03** Implement `CompanionNPC` extending `BaseNPC`: second avatar logic, player/companion control switch, co-op handoff on controller connect.
- [ ] **3.04** Implement `NPCHomeData`: terrain preference, facing direction, proximity preferences. Validation function returns true when all preferences met.
- [ ] **3.05** Name and spec all 4 starter NPCs for The Ember Hollow. Write YAML definitions in `data/npcs/`.
- [ ] **3.06** Name and spec all 4 starter NPCs for The Tidemark. Write YAML definitions.
- [ ] **3.07** Name and spec all 4 starter NPCs for The Forge Run. Write YAML definitions.
- [ ] **3.08** Name and spec all 4 starter NPCs for The Rootstead. Write YAML definitions.
- [ ] **3.09** Name and spec all 4 starter NPCs for The Spire. Write YAML definitions.
- [ ] **3.10** Name and spec all 4 starter NPCs for The Drift. Write YAML definitions.
- [x] **3.11** Write 2 quests per starter NPC (minimum 48 total quests). Each quest must have all 8 required fields, research_basis citation, and scaffolding. Reviewed by parent before committing.
- [x] **3.12** Write fallback dialogue JSON for all starter NPCs (24 files in `data/dialogue/`).
- [x] **3.13** Write Ignavarr fallback dialogue for all tutorial stages and nightly review prompts.
- [ ] **3.14** NPC home preference side quests: Builder's Guild NPC in Hearthveil. At least 3 NPCs have home preferences defined and fulfillable.
- [ ] **3.15** Quest cross-reference table: for each subcategory, list all quest IDs that address it. Stored in `data/quest_index.json`. Used by parent dashboard.
- [ ] **3.16** Verify quest loading for all 48+ quests in headless: no validation errors, all fields present, all quests loadable.

---

## 4.00 Realm Overworld Builds
> Goal: All 7 realm overworld scenes navigable with placeholder geometry. NPCs placed and functional.

- [ ] **4.01** The Ember Hollow overworld: biome geometry, NPC spawn points for 4 starters, portal to dungeon, ambient particle placeholder.
- [ ] **4.02** The Tidemark overworld: coastal feel, lighthouse placeholder, NPC spawns, dungeon portal.
- [ ] **4.03** The Forge Run overworld: mountain/volcanic feel, obstacle elements, NPC spawns, dungeon portal. Summit Bonus Area sealed door with lore note for base players.
- [ ] **4.04** The Rootstead overworld: village feel, kitchen/garden areas, NPC spawns, dungeon portal.
- [ ] **4.05** The Spire overworld: floating island/clockwork feel, NPC spawns, dungeon portal.
- [ ] **4.06** The Drift overworld: ever-shifting geometry (randomized layout seed per visit), NPC spawns, dungeon portal.
- [ ] **4.07** Hearthveil full build: cobblestone village, 7 portal arches, Ignavarr's Keep, Player's House exterior, Pet Sanctuary, Builder's Guild, Market Square.
- [ ] **4.08** Realm portal system: portal glows when quests available, dims when all complete. Locks until unlock condition met.
- [ ] **4.09** Ground mount system: mount entity, riding animation placeholder, movement speed increase. Unlocks at level 25.
- [ ] **4.10** Wisp slot 1 entity in overworld: follows player, element trail particle, idle/following/playing states.
- [ ] **4.11** Hearthveil ambient NPCs: at least 3 non-teacher ambient NPCs with single-line dialogue for world feel.
- [ ] **4.12** Market/shop NPC: cosmetic shop. Gold only. No power items. Shows item previews.
- [ ] **4.13** NPC home preference system: valid plot markers in each realm. Builder's Guild quest system. Visual feedback when preferences met.
- [ ] **4.14** Verify all 7 overworld scenes load, player can walk through each, portals trigger scene transitions.

---

## 5.00 Dungeon System
> Goal: All 6 dungeons playable with placeholder art. Turn-based Wisp battle functional.

- [ ] **5.01** Dungeon scene architecture: 2D scene type, side-scrolling camera, CharacterBody2D player, TileMap ground. Separate from 3D overworld — no shared physics.
- [ ] **5.02** Dungeon layout: Entry Chamber (safe, NPC guide), 3 sections (simple→complex mechanic), Boss Chamber, Victory Room.
- [ ] **5.03** Wisp battle system: turn-based. Educational check per encounter. Resolve meter fills on correct answer. No "defeat" language — "calm", "resolve", "befriend."
- [ ] **5.04** Crystal type system: 7 crystal types, effectiveness table (1.5x advantage, 0.75x resistance). Combo crystal logic for level 6+ players.
- [ ] **5.05** Wisp capture: 30% base chance on first encounter per species. Adds to `user://save/wisp_roster.json`.
- [ ] **5.06** Dungeon team selection: pre-dungeon screen. Player selects up to 3 Wisps from roster. Different from traveling party.
- [ ] **5.07** Mini-boss encounters: 1-2 per run, random placement. Stronger than standard, weaker than end boss.
- [ ] **5.08** End-of-dungeon boss: multi-phase. Phase 1 battle. Phase 2 puzzle layer added to same encounter.
- [ ] **5.09** The Mirror Maze (Ember Hollow): emotion-matching puzzle gates. Crystal type advantage tied to emotion categories.
- [ ] **5.10** The Word Caverns (Tidemark): phonics/spelling gates. Bridge extends on correct letter placement.
- [ ] **5.11** The Obstacle Forge (Forge Run): precision platforming. Timing challenges. Wii balance board variant for balance sections.
- [ ] **5.12** The Daily Tower (Rootstead): order-of-operations puzzle rooms. Multi-step life skill sequences.
- [ ] **5.13** The Gear Gauntlet (Spire): cause-and-effect chain puzzles. Memory sequence gates.
- [ ] **5.14** The Curiosity Cave (Drift): roguelite layout, different each run. No map provided. Exploration is the lesson.
- [ ] **5.15** Dungeon unlock gate: checks 3 NPC discoveries in realm before allowing entry. Shows requirement if locked.
- [ ] **5.16** Dungeon rewards: battle loot, completion rewards, first-clear bonuses. All flowing through `QuestReward`.
- [ ] **5.17** Verify all 6 dungeons: load, player can navigate, one battle completes correctly, rewards granted, return to overworld works.

---

## 6.00 Embral's Trials
> Goal: All 6 trials functional at base level. Hardware variants documented and stubbed.

- [ ] **6.01** Trial unlock gate: 3 NPCs discovered in realm. Trial portal appears in overworld.
- [ ] **6.02** Trial architecture: arena scene (can reuse dungeon scene type), Ignavarr narration trigger, multi-phase encounter manager.
- [ ] **6.03** The Heart Trial (Ember Hollow): emotion identification phases. Base: multiple choice. Wii: balance board sway mechanic stub. PS5: haptic pulse stub.
- [ ] **6.04** The Word Surge (Tidemark): spelling bridge build. Base: on-screen keyboard. Wii: IR pointer letter placement stub.
- [ ] **6.05** The Forge Gauntlet (Forge Run): physical challenge. Base: precision platformer. Wii: balance board + wiimote + nunchuck combined stub. PS5: motion dodge stub. This is the hardware showcase trial.
- [ ] **6.06** The Life Lodge Trial (Rootstead): life skill sequence. Base: order-of-operations UI. Wii: gesture-based action stub.
- [ ] **6.07** The Vault Challenge (Spire): math/logic under pressure. Base: puzzle UI with adaptive difficulty. PS5: haptic confirm stub.
- [ ] **6.08** The Creation Crucible (Drift): creative challenge under timer. Base: selection/drawing UI. Wii: motion drawing stub.
- [ ] **6.09** Realm seal reward: granted on first trial win. Displayed in Player's House trophy room.
- [ ] **6.10** Trial failure handling: unlimited retries. No penalty. Ignavarr warm failure dialogue unique per trial.
- [ ] **6.11** Verify all 6 trials: load, base mechanics complete, rewards granted, realm seal appears in trophy room.

---

## 7.00 Creature System
- [ ] **7.01-7.13** Wisps, Pets, Companions systems.

---

## 8.00 Family Systems
- [ ] **8.01-8.20** Nightly reviews, Family Raids, Mini-games.

---

## 9.00 Hardware Integrations
- [ ] **9.01-9.21** PS5, Wii, HA, ESP32/Arduino/Pi.

---

## 10.00 Parent Dashboard
- [ ] **10.01-10.12** Dashboard build & verification.

---

## 11.00 Ops / Observability
- [ ] **11.01-11.10** Logging, Metrics, Replayable tests, Automation.

---

## 12.00 Final Hardening
- [ ] **12.01-12.12** Core progression loop, Ascension, Stress tests, Accessibility.

---

## 13.00 Release Hardening
- [ ] **13.01-13.12** Freeze, Smoke tests, Verify full loop, Release scorecard.
