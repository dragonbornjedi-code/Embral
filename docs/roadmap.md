# Embral Project Roadmap (Resilience-First)

> **Living Document.** Every step must be completed, tested, and verified before marking DONE.
> Status labels: DONE | PARTIAL | STUB | PLANNED | DEFERRED | BROKEN

**Current Phase:** 2.00 Reliability — Starting
**Godot Version:** 4.5.stable.official.876b29033
**Last Sync:** 2026-04-20
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
- [!] **1.02** ~~SQLite binding~~ — **REMOVED.** godot-sqlite was added by Windsurf without authorization. Embral uses Godot JSON + FileAccess. Removing it fixed GDExtension startup errors. Do not re-add.
- [x] **1.03** Dialogic 2 v2.0-Alpha-19 on disk, enabled, runtime-verified. `dialogic_stub.gd` launches real timelines or falls back to JSON.
- [x] **1.04** `SaveManager` schema v1 with v0 migration. Unknown versions quarantined.
- [x] **1.05** Quest JSON validation: 8 required fields checked on load. Missing fields logged and rejected.
- [x] **1.06** Content quarantine: invalid quest files logged with reason and not loaded.
- [x] **1.07** Fallback dialogue: `dialogic_stub.gd` returns fallback line when Dialogic missing.
- [x] **1.08** HA Safe Mode: `ha_bridge._safe_mode` reads from config. All HA methods guarded.
- [x] **1.09** LimboAI `addons/demo/` folder **REMOVED.** It caused preload errors (res://demo/... paths). LimboAI itself untouched.
- [x] **1.10** Boot root changed from `Node2D` to `Node`. Scene transition deferred. Headless boot clean.
- [ ] **1.11** Verify `dialogic_stub.gd` actually launches a real Dialogic timeline end-to-end with a test NPC. Timeline integration pending — mark DONE only after live test.
- [ ] **1.12** Verify `save_manager.gd` can write, read, and migrate a save file in headless mode with explicit assertion output.
- [ ] **1.13** Verify `quest_manager.gd` loads a sample quest JSON, validates all 8 fields, and emits `quest_started` signal in headless test.
- [ ] **1.14** Add `docs/SESSION.md` update to the end of every CI/AI session as enforced habit. Verify it was updated in last 3 sessions.

---

## 2.00 Reliability / Core Systems
> Goal: Core game systems functional. Player can walk around Hearthveil, talk to Ignavarr, and receive a quest.

- [ ] **2.01** Fix main menu scene: `scenes/ui/main_menu.tscn` loads without VBoxContainer parent path errors. Verify in headless.
- [ ] **2.02** Main menu displays: Profile list, New Game, Continue, Settings, Parent Dashboard (PIN-gated). No art needed — white-box UI.
- [ ] **2.03** Profile system: create, select, and delete player profiles. Each profile has its own `user://save/{profile_id}/` directory.
- [ ] **2.04** Implement `PlayerProfile` data class: level, XP, gold, raid_points, play_points, quest_completion dict.
- [ ] **2.05** Implement `PartyManager`: player + companion slot + 3 wisp slots + 3 companion wisp slots. Max 6 traveling. Max 4 rendered.
- [ ] **2.06** Implement `PlayerController`: keyboard/mouse movement, camera follow, interact button. Reads from `HardwareManager` only.
- [ ] **2.07** Hearthveil white-box scene: flat plane, 7 portal placeholder markers, Ignavarr spawn point, Player's House spawn point, Pet Sanctuary spawn point. No art — geometry only.
- [ ] **2.08** Ignavarr NPC script: proximity detection, interact trigger, dialogue launch via `dialogic_stub.gd`. Fallback JSON defined.
- [ ] **2.09** Tutorial sequence: Ignavarr walks player through movement, interaction, and completing Ignavarr's house request. Completion unlocks Player's House marker.
- [ ] **2.10** Player's House scene: stub interior. Pet area placeholder. Companion registry placeholder. Trophy room placeholder. Accessible after tutorial.
- [ ] **2.11** Hearthveil portal markers: each portal shows realm name and lock state. Locked portals show requirement text.
- [ ] **2.12** `QuestManager` end-to-end test: load quest JSON, run steps, record score, grant rewards, verify NPC mastery updates.
- [ ] **2.13** `SaveManager` end-to-end test: save game state after quest completion, reload, verify all data intact.
- [ ] **2.14** HUD scene: XP bar, gold counter, active quest name, party portrait row (player + companion slot + wisp slot 1). No art needed.
- [ ] **2.15** Emotional check-in: pop-up at game start and every 30 minutes. Four modes (face, color, number, weather). Reward identical regardless of answer. Stores to `user://save/parent_dashboard.json`.
- [ ] **2.16** Settings menu: volume sliders, fullscreen toggle, hardware expansion enables/disables, emotional check-in frequency, parent PIN setup.
- [ ] **2.17** Parent dashboard stub: PIN entry screen, placeholder panels for each tracked metric. No data yet — just structure and navigation.
- [ ] **2.18** Integrate Phantom Camera for smooth 3D overworld camera transitions.
- [ ] **2.19** Scene transition system: loading screen between overworld/dungeon with realm-appropriate placeholder art.
- [ ] **2.20** Verify entire flow headless: boot → main menu → profile select → hearthveil → talk to Ignavarr → receive quest → complete quest → XP granted → save.

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
- [ ] **3.11** Write 2 quests per starter NPC (minimum 48 total quests). Each quest must have all 8 required fields, research_basis citation, and scaffolding. Reviewed by parent before committing.
- [ ] **3.12** Write fallback dialogue JSON for all starter NPCs (24 files in `data/dialogue/`).
- [ ] **3.13** Write Ignavarr fallback dialogue for all tutorial stages and nightly review prompts.
- [ ] **3.14** NPC home preference side quests: Builder's Guild NPC in Hearthveil. At least 3 NPCs have home preferences defined and fulfillable.
- [ ] **3.15** Quest cross-reference table: for each subcategory, list all quest IDs that address it. Stored in `data/quest_index.json`. Used by parent dashboard.
- [ ] **3.16** Verify quest loading for all 48+ quests in headless: no validation errors, all fields present, all quests loadable.

---

## 4.00 Realm Overworld Builds
> Goal: All 7 realm overworld scenes navigable with placeholder geometry. NPCs placed and functional.

- [ ] **4.01** The Ember Hollow overworld: biome geometry (enchanted forest feel — basic mesh shapes), NPC spawn points for 4 starters, portal to dungeon, ambient particle placeholder.
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
> Goal: Wisps capturable and functional. Pets interactive at home. Companions switchable.

- [ ] **7.01** Wisp data model: element, level, XP, evolution_tier, abilities array, nickname, capture_date.
- [ ] **7.02** Wisp evolution system: tier 1→2 at level 30 + 10 matching essence. Tier 2→3 at level 50 + 10 more. Visual changes per tier.
- [ ] **7.03** Wisp party system: slot 1-3 per character. Slot 1 rendered in overworld. Party selection UI before dungeon.
- [ ] **7.04** Pet data model: species, happiness (0-100, floor 20), level, accessories array.
- [ ] **7.05** Pet mini-game at Player's House: feed, play fetch, groom, read together, nap together. Happiness increases per activity.
- [ ] **7.06** Pet passive bonuses: happiness tiers 40-59 (+2% gold), 60-79 (+5% gold +3% XP), 80-100 (+8% gold +5% XP +3% rare find).
- [ ] **7.07** Pet roster management UI: view all pets at home, select 3 to display in house. Max 20 at home.
- [ ] **7.08** Companion system: creation screen (same as player avatar creator). Player names companion. Stored in `user://save/`.
- [ ] **7.09** Companion switch: can swap at Player's House or Ignavarr's. Previous companion returns to home.
- [ ] **7.10** Companion co-op: second controller/keyboard detected → companion becomes player-controlled. Auto-AI when no second player.
- [ ] **7.11** Companion wisp slots: companion has own 3 wisp slots. Companion's slot 1 wisp visible in overworld near companion.
- [ ] **7.12** Companion home capacity: starts at 1. +1 every 25 player levels. UI shows capacity and occupied slots.
- [ ] **7.13** Verify creature system end-to-end: capture wisp in dungeon → appears in roster → equip to party → visible in overworld → evolve with essence.

---

## 8.00 Family Systems
> Goal: Nightly review, Weekend Family Raid, and mini-games fully functional.

- [ ] **8.01** Nightly Review portal in Hearthveil: accessible from main menu and overworld. Ignavarr hosts.
- [ ] **8.02** Review question display: 4 questions with visual icons. Ezra taps or parent reads aloud. No wrong answers.
- [ ] **8.03** Raid Point orb: visible to parent only (PIN-gated toggle). Parent taps when threshold moment occurs. Stores to `parent_dashboard.json`.
- [ ] **8.04** Raid Point counter: visible in Parent Dashboard. Weekly counter (Mon-Sun). Resets Monday.
- [ ] **8.05** Weekend Family Raid unlock: Friday notification from Ignavarr when 3+ raid points earned. Raid activates Sat/Sun.
- [ ] **8.06** Family Raid manager: 8 raid types (knowledge, physical, creative, card game, cooking, story, nature, failure acceptance). Random selection with parent override option.
- [ ] **8.07** Failure Acceptance Raid specifically: Ignavarr dialogue ONLY triggers on collapse event. Collapse mechanically unlocks extra dialogue. Failure rewarded.
- [ ] **8.08** Family Raid boss encounter: final challenge tied to raid type. Unlimited retries. Warm failure tone always.
- [ ] **8.09** Family Raid Shop: unlocked on completion. Closes following Monday. 3 items from rotation pool. Gold from raid session only.
- [ ] **8.10** Memory Crystal: granted on raid completion. Appears in Player's House trophy room. Grows more elaborate over time.
- [ ] **8.11** Weekly review mode: longer Sunday version. Awards 2 Raid Points on completion. Ignavarr shows week highlights as storybook.
- [ ] **8.12** Mini-game manager: handles 1-4 player local sessions. Detects available input devices via HardwareManager.
- [ ] **8.13** Wisp Match mini-game: memory card matching. 1-4 players. Tied to Spire pattern recognition quest.
- [ ] **8.14** Word Catch mini-game: falling words, catch rhymes. 1-2 players. Tied to Tidemark phonics quest.
- [ ] **8.15** Number Race mini-game: equation first-tap wins. 1-4 players. Tied to Spire math quest.
- [ ] **8.16** Feeling Sort mini-game: emotion categorization. 1-4 players. Tied to Ember Hollow emotion ID quest.
- [ ] **8.17** Balance Trial mini-game: Wii balance board hold. 1-2 players alternating. Base fallback: one-foot stand.
- [ ] **8.18** Letter Bounce mini-game: collect letters to spell target word. 1-2 players. Tied to Tidemark spelling quest.
- [ ] **8.19** Play Points shop: items exclusive to Play Points. Cannot be bought with gold.
- [ ] **8.20** Verify family systems: complete a nightly review, earn 3 raid points over 3 sessions, trigger family raid, complete it, access raid shop.

---

## 9.00 Hardware Integrations
> Goal: PS5 and Wii hardware integrations functional. HA Green integration functional. Each adds depth with verified fallback.

- [ ] **9.01** PS5 DualSense: haptic feedback on quest completion (celebration pulse). Verified on Ezra's machine.
- [ ] **9.02** PS5 DualSense: haptic confirm on correct quest answers. Distinct from quest completion pulse.
- [ ] **9.03** PS5 DualSense: LED bar syncs to current realm color (Ember Hollow = orange, Tidemark = blue, etc.).
- [ ] **9.04** PS5 DualSense: adaptive trigger resistance for effort-feedback mechanics in Forge Gauntlet trial.
- [ ] **9.05** PS5 DualSense: motion control dodge roll in Forge Gauntlet trial. Base fallback: button dodge.
- [ ] **9.06** Wii Wiimote: install xwiimote driver on Ezra's machine. Verify `/proc/bus/input/devices` shows Nintendo Wii.
- [ ] **9.07** Wii Wiimote: swing detection — horizontal, vertical, thrust, spin. Map to dungeon actions.
- [ ] **9.08** Wii Nunchuck: analog stick movement in overworld and dungeon. C/Z buttons mapped.
- [ ] **9.09** Wii Balance Board: center-of-balance tracking. Lean left/right/forward/back detection.
- [ ] **9.10** Wii Balance Board: integrated in Forge Gauntlet physical challenge. Lean = dodge/charge.
- [ ] **9.11** Wii Balance Board: Balance Trial mini-game. Hold center wins. PS5 fallback: button hold.
- [ ] **9.12** Wii IR Camera: precision pointing for Word Surge trial letter placement.
- [ ] **9.13** HA Green integration: `ha_bridge.gd` connects to HA Green on Ezra's local network. Circuit breaker tested.
- [ ] **9.14** HA Green: realm entry triggers light color change. Ember Hollow = warm orange. Tidemark = cool blue. etc.
- [ ] **9.15** HA Green: quest completion triggers celebration light sequence.
- [ ] **9.16** HA Green: Ignavarr speaks through Ezra's room speaker via Piper TTS for morning greeting.
- [ ] **9.17** HA Green: Life Lodge quests (hygiene, routines) verified by real-world sensor data when HA available.
- [ ] **9.18** ESP32 stub: HTTP endpoint ping at startup. Placeholder for future gadget integrations.
- [ ] **9.19** Arduino stub: serial port scan at startup. Placeholder for future gadget integrations.
- [ ] **9.20** Pi stub: HTTP endpoint ping at startup. Placeholder for future integrations.
- [ ] **9.21** All hardware fallbacks verified: disconnect PS5, Wii, and HA while game is running. Game continues without crash or error.

---

## 10.00 Parent Dashboard (Full Build)
> Goal: Parent can open dashboard, view Ezra's progress across all domains, and understand strengths/needs.

- [ ] **10.01** PIN entry gate: numeric PIN, configurable in settings. Locks parent dashboard.
- [ ] **10.02** Realm progress view: XP earned and time spent per realm. Visual bar chart per realm.
- [ ] **10.03** NPC mastery view: per-NPC mastery level 1-5. Shows which NPCs have reached each tier.
- [ ] **10.04** Subcategory strength map: cross-references quest completions to developmental subcategories. Shows relative strength/need across all domains.
- [ ] **10.05** Emotional check-in history: timeline of check-in responses. Mood trend over time. Flagging patterns (e.g. consistently stormy before certain quest types).
- [ ] **10.06** Response latency tracking: per quest step, time between prompt display and answer. Flags consistently fast answers (guessing) vs slow (thinking or struggling).
- [ ] **10.07** Retry count display: shows which quests Ezra retried most. Highest retry = potential difficulty area.
- [ ] **10.08** Teaching style comparison: which quest formats (multiple choice, physical, creative, narrative) get highest mastery scores. Helps identify learning style.
- [ ] **10.09** Raid Point history: shows which evenings had review sessions and which triggered raid points. Weekly calendar view.
- [ ] **10.10** Session timeline: simple log of what Ezra did each session. Realm visited, quests completed, time played.
- [ ] **10.11** Export report: parent can generate a plain-text summary of Ezra's progress for sharing with teachers or therapists.
- [ ] **10.12** Verify dashboard: complete 5 quests across 2 realms, do 3 emotional check-ins, open parent dashboard and verify all data appears correctly.

---

## 11.00 Ops / Observability
- [ ] **11.01** Structured logging for all major systems: quest load/fail, save write/read, NPC discover, hardware connect/disconnect.
- [ ] **11.02** Metrics counters: failed quest loads, fallback dialogue uses, HA offline events, save migration events.
- [ ] **11.03** Debug overlay toggle (F12 in dev builds): shows realm/quest/hardware/save status at runtime.
- [ ] **11.04** Replayable test sequences: headless Godot scripts that simulate: boot → profile → hearthveil → tutorial → quest → save → reload.
- [ ] **11.05** Plugin version hashes in `docs/compatibility.md`. Verified against actual installed versions.
- [ ] **11.06** "Last Good Build" git tag protocol: after every phase completion, tag with `phase-X-complete`.
- [ ] **11.07** Runtime warnings captured to `user://logs/warnings.log`. Accessible from Parent Dashboard.
- [ ] **11.08** Forensic log: all autoload failures, missing asset warnings, schema migration events.
- [ ] **11.09** MCP/Godot AI plugin health check in boot sequence. Reports status at startup.
- [ ] **11.10** Automated quest validation script: runs against all JSON in data/quests/, reports any missing required fields.

---

## 12.00 Final Hardening
- [ ] **12.01** Implement core progression loop: tutorial → realm explore → NPC discover → quest → dungeon → trial → ascension.
- [ ] **12.02** Ascension at level 100: world visual update, new NPC dialogue trees, new Ignavarr story chapter, flying mount unlock.
- [ ] **12.03** All external hardware integrations have verified circuit breakers tested with hardware disconnected mid-session.
- [ ] **12.04** Stress test: corrupt a save file manually. Verify game loads in safe mode, offers recovery, does not crash.
- [ ] **12.05** Stress test: delete `user://save/` entirely. Verify new game starts cleanly.
- [ ] **12.06** Stress test: 50 quests completed in one session. Verify save integrity and no memory leaks.
- [ ] **12.07** Save migration automated test: create v0 save manually, load with v1 SaveManager, verify all data migrated correctly.
- [ ] **12.08** Fail Closed minimal boot mode: if any autoload fails, game boots to safe minimal state with error message rather than crashing.
- [ ] **12.09** All realm-specific educational logic verified: each realm's dungeon teaches the same domain as its overworld via different modality.
- [ ] **12.10** Verify no IP violations anywhere in repo: search all files for banned character names, licensed terms.
- [ ] **12.11** Verify no hardcoded IPs, tokens, or paths that assume a specific machine exist in any committed file.
- [ ] **12.12** Accessibility review: all mini-games playable without specific hardware. All content accessible from keyboard. Text size readable on Ezra's screen.

---

## 13.00 Release Hardening
- [ ] **13.01** Freeze milestone build. Tag git: `v0.1.0-first-playable`.
- [ ] **13.02** Full smoke test suite: movement in all 7 realms, dialogue with all 24 starter NPCs, one quest per realm, one dungeon per realm, one trial.
- [ ] **13.03** Confirm 100% editor-free completion of one full loop: tutorial → quest → dungeon → trial → save → reload → continue.
- [ ] **13.04** Parent dashboard verified with real play data from at least 3 sessions.
- [ ] **13.05** All 48+ quests load without validation errors.
- [ ] **13.06** All 6 dungeons completable without crashing.
- [ ] **13.07** All 6 trials completable at base (keyboard) level.
- [ ] **13.08** Hardware expansions gracefully degrade when hardware disconnected.
- [ ] **13.09** Family systems verified: complete one full weekly cycle (reviews → raid → shop).
- [ ] **13.10** README.md updated to reflect current game state.
- [ ] **13.11** AGENTS.md, manifest.yaml, and SESSION.md are all current.
- [ ] **13.12** Final release scorecard: all Phase 0-12 items are DONE or DEFERRED with documented reasons.
