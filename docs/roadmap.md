# Embral Project Roadmap (100% Playable Build)

> **Living Document.** Every step must be completed, tested, and verified before marking DONE.
> Status labels: DONE | PARTIAL | PLANNED | DEFERRED | BROKEN

**Current Phase:** 13.00 Release Hardening
**Godot Version:** 4.5.stable.official.876b29033
**Last Sync:** 2026-04-25

---

## STATUS KEY
- [x] = DONE — runtime or file verified
- [~] = PARTIAL — exists but not fully complete
- [ ] = PLANNED — not started
- [!] = BROKEN — known issue, needs repair
- [-] = DEFERRED — intentionally postponed

---

## 0.00 Foundation
- [x] **0.01** Record verified Godot 4.5.x runtime build. `4.5.stable.official.876b29033`
- [x] **0.02** Create Git backup and restore point.
- [x] **0.03** Define source-of-truth hierarchy.
- [x] **0.04** Create docs/compatibility.md.
- [x] **0.05** Create minimal boot scene.
- [x] **0.06** Finalize EventBus with all signals.
- [x] **0.07** Establish naming conventions.
- [x] **0.08** Verify test scenes.
- [x] **0.09** AGENTS.md v2.0 committed.
- [x] **0.10** manifest.yaml v2.0 committed.
- [x] **0.11** docs/SESSION.md established.
- [x] **0.12** Install shell alias system.
- [x] **0.13** .cursorrules committed.
- [x] **0.14** docs/AI_CONTEXT.md maintained.

## 1.00 Safety / Integrity
- [x] **1.01** LimboAI v1.6.0 runtime-verified.
- [x] **1.02** SQLite binding REMOVED.
- [x] **1.03** Dialogic 2 v2.0-Alpha-19 runtime-verified.
- [x] **1.04** SaveManager schema v1 with migration.
- [x] **1.05** Quest JSON validation (8 required fields).
- [x] **1.06** Content quarantine logic.
- [x] **1.07** Fallback dialogue system.
- [x] **1.08** HA Safe Mode circuit breaker.
- [x] **1.09** LimboAI demo/ folder removed.
- [x] **1.10** Boot root changed to Node.
- [x] **1.11** DialogicStub real timeline verified.
- [x] **1.12** SaveManager headless write/read verified.
- [x] **1.13** QuestManager headless verification.
- [x] **1.14** SESSION.md update enforced.

## 2.00 Reliability / Core Systems
- [x] **2.01** Fix main menu scene VBoxContainer errors.
- [x] **2.02** Main menu profile UI.
- [x] **2.03** Profile system create/select/delete.
- [x] **2.04** PlayerProfile data class.
- [x] **2.05** PartyManager stub.
- [x] **2.06** PlayerController input and camera.
- [x] **2.07** Hearthveil white-box scene.
- [x] **2.08** Ignavarr NPC script and interact.
- [x] **2.09** Tutorial sequence complete.
- [x] **2.10** Player's House stub.
- [x] **2.11** Hearthveil portal markers.
- [x] **2.12** QuestManager end-to-end test.
- [x] **2.13** SaveManager end-to-end test.
- [x] **2.14** HUD scene: XP bar, gold, active quest.
- [x] **2.15** Emotional check-in: 30-min timer, storage.
- [x] **2.16** Settings menu: volume, fullscreen, hardware toggles.
- [x] **2.17** Parent dashboard: PIN entry, emotional history.
- [x] **2.18** Simple follow camera (lerp-based).
- [x] **2.19** Scene transition system (fade in/out).
- [x] **2.20** Full headless flow verification.

## 3.00 NPC System / Quest Content Foundation
- [x] **3.01** BaseNPC system with proximity detection.
- [x] **3.02** CompanionNPC logic and AI follow.
- [x] **3.03** NPCHomeData preferences.
- [x] **3.04** Ember Hollow 4 starter NPCs.
- [x] **3.05** Ember Hollow 8 quest JSONs.
- [x] **3.06** Tidemark 4 NPCs + 8 quests.
- [x] **3.07** Forge Run 4 NPCs + 8 quests.
- [x] **3.08** Rootstead 4 NPCs + 8 quests.
- [x] **3.09** The Spire 4 NPCs + 8 quests.
- [x] **3.10** The Drift 4 NPCs + 8 quests.
- [x] **3.11** 2 quests per NPC — 51 total quests.
- [x] **3.12** 25 fallback dialogue JSON files.
- [x] **3.13** Ignavarr teacher script and quest index.
- [x] **3.14** 25 NPC scene instances.
- [x] **3.15** Ignavarr placement in Hearthveil verified.
- [x] **3.16** Builder's Guild NPC stub.

## 4.00 Overworld Builds
- [x] **4.01** Hearthveil full build with portal arches.
- [x] **4.02** Ember Hollow overworld with NPCs placed.
- [x] **4.03** All 7 realm overworlds built.
- [x] **4.04** Portal unlock logic (NPC discovery count).
- [x] **4.05** Embral Trials scenes (6 stubs).
- [x] **4.06** Trial portal markers in each realm.

## 5.00 Creature System
- [x] **5.01** WispData model with element and XP.
- [x] **5.02** PetData model with hunger and happiness.
- [x] **5.03** CompanionData model.
- [x] **5.04** PlayerProfile full data class.
- [x] **5.05** WispRoster save/load utility.
- [x] **5.06** Wisp encounter system with capture.
- [x] **5.07** Wisp entity overworld follower.
- [x] **5.08** Wisp Slot 1 wired into PlayerController.
- [x] **5.09** Pet minigame (feed, play, happiness).
- [x] **5.10** Pet Sanctuary scene in Hearthveil.
- [x] **5.11** Wisp capture flow complete.
- [x] **5.12** Companion party management.

## 6.00 Embral's Trials
- [x] **6.01** Heart Trial — emotion identification, 5 questions.
- [x] **6.02** Word Surge — missing letter phonics, 5 words.
- [x] **6.03** Forge Gauntlet — rhythm timing, 5 rounds.
- [x] **6.04** Vault Challenge — number matching, 5 rounds.
- [-] **6.05** Life Lodge Trial — DEFERRED (complex life skills mechanics).
- [-] **6.05** Creation Crucible — DEFERRED (complex creative mechanics).
- [x] **6.06** Trial unlock gates (3 NPC discoveries required).

## 7.00 Creature Battle System
- [x] **7.01** Wisp Battle UI and Manager.
- [x] **7.02** Ability system with element effectiveness.
- [x] **7.03** Battle SFX manager (EventBus bridge).
- [x] **7.04** Educational check engine stub.

## 8.00 Family Systems
- [x] **8.01** Nightly Review (Ignavarr hosted, Raid Point mechanic).
- [x] **8.02** Raid Point persistence in SaveManager.
- [x] **8.03** Family Raid Manager (8 raid types).
- [x] **8.04** Family Raid Shop (cosmetic items only).
- [x] **8.05** Mini-game Manager.
- [x] **8.06** Wisp Match (memory card game).
- [x] **8.07** Word Catch (missing letter spelling).
- [x] **8.08** Number Race (math speed, 10 questions).
- [x] **8.09** Emotion Sort (drag to buckets, no wrong answers).
- [x] **8.10** Balance Trial (timing bar, 5 rounds).
- [x] **8.11** Letter Bounce (letter sound matching).

## 9.00 Hardware Integrations
- [x] **9.01** PS5 DualSense haptic and LED feedback.
- [x] **9.02** Wii hardware detection stub.
- [x] **9.03** Home Assistant realm light integration.
- [ ] **9.04** ESP32/Arduino serial bridge.
- [ ] **9.05** Raspberry Pi HTTP integration.
- [ ] **9.06** Wii Balance Board calibration (Phase 9 extension).
- [ ] **9.07** Wiimote IR pointer (Phase 9 extension).

## 10.00 Parent Dashboard
- [x] **10.01** Emotional check-in history display.
- [x] **10.02** Session timeline (quests + check-ins).
- [x] **10.03** PIN security with SHA256 hashing.
- [x] **10.04** Realm XP progress display.
- [x] **10.05** NPC mastery summary display.

## 11.00 Ops / Observability
- [x] **11.01** ErrorLogger autoload (local file logging).
- [x] **11.02** Telemetry autoload (event tracking, flush on exit).
- [ ] **11.03** Replayable test scenes.
- [ ] **11.04** CI/CD automated build script.

## 12.00 Final Hardening
- [x] **12.01** Progression loop audit (all checks pass).
- [x] **12.02** Hardcoded name removal (no "Ezra" in code).
- [x] **12.03** Accessibility pass (ui_cancel, focus on open).
- [ ] **12.04** Stress test (spawn 100 NPCs simultaneously).

## 13.00 Release Hardening
- [ ] **13.01** Release candidate freeze.
- [ ] **13.02** Smoke tests (fresh boot, fresh save).
- [ ] **13.03** Full game loop walkthrough.
- [ ] **13.04** Final release scorecard.

---

## REMAINING WORK SUMMARY

Completed: Phases 0-12 core systems
In progress: Phase 13 release hardening
Deferred: Life Lodge Trial, Creation Crucible, ESP32/Pi hardware, CI/CD
Next task: 13.02 smoke tests and full loop walkthrough
