# Embral Project Roadmap (100% Playable Build)

> **Living Document.** Every step must be completed, tested, and verified before marking DONE.
> Status labels: DONE | PARTIAL | PLANNED | DEFERRED | BROKEN

**Current Phase:** 7.00 Creature Battle System
**Godot Version:** 4.5.stable.official.876b29033

---

## 0.00 Foundation
- [x] **0.01** Record verified Godot 4.5.x runtime build.
- [x] **0.02** Create Git backup and restore point.
- [x] **0.03** Define source-of-truth hierarchy.
- [x] **0.04** Create docs/compatibility.md.
- [x] **0.05** Create minimal boot scene.
- [x] **0.06** Finalize EventBus.
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
- [x] **1.04** SaveManager schema v1.
- [x] **1.05** Quest JSON validation (8 fields).
- [x] **1.06** Content quarantine logic.
- [x] **1.07** Fallback dialogue system.
- [x] **1.08** HA Safe Mode.
- [x] **1.09** Cleaned LimboAI demo/ folder.
- [x] **1.10** Boot root changed to Node.
- [x] **1.11** Verify dialogic_stub.gd real timeline launch.
- [x] **1.12** SaveManager headless cycle verified.
- [x] **1.13** QuestManager headless verification.
- [x] **1.14** Enforce SESSION.md updates.

## 2.00 Reliability / Core Systems
- [x] **2.01** Fix main menu scene.
- [x] **2.02** Main menu profile UI.
- [x] **2.03** Profile system create/delete.
- [x] **2.04** PlayerProfile data class.
- [x] **2.05** PartyManager stub.
- [x] **2.06** PlayerController input/camera.
- [x] **2.07** Hearthveil white-box scene.
- [x] **2.08** Ignavarr NPC script/interact.
- [x] **2.09** Tutorial sequence complete.
- [x] **2.10** Player's House stub.
- [x] **2.11** Hearthveil portal markers.
- [x] **2.12** QuestManager E2E test.
- [x] **2.13** SaveManager E2E test.
- [x] **2.14** HUD scene: XP bar, gold, quest info.
- [x] **2.15** Emotional check-in: 30-min timer/storage.
- [x] **2.16** Settings menu: volume, fullscreen, hardware toggles.
- [x] **2.17** Parent dashboard: PIN entry, emotional history.
- [x] **2.18** Simple follow camera (lerp-based).
- [x] **2.19** Scene transition system (fade).
- [x] **2.20** Full headless flow verification.

## 3.00 NPC System / Quest Content Foundation
- [x] **3.01** BaseNPC system.
- [x] **3.02** Companion NPC logic.
- [x] **3.03** NPC home preference data.
- [x] **3.04** Ember Hollow starter NPCs.
- [x] **3.05** Hearthveil/Ember Hollow quest JSONs.
- [x] **3.06** Tidemark NPCs.
- [x] **3.07** Forge Run NPCs.
- [x] **3.08** Rootstead NPCs.
- [x] **3.09** Spire NPCs.
- [x] **3.10** Drift NPCs.
- [x] **3.11** 2 quests per NPC (51 total).
- [x] **3.12** Fallback dialogue JSONs.
- [x] **3.13** Ignavarr fallback logic.
- [x] **3.14** NPC scene instances (25).
- [x] **3.15** Ignavarr placement verified.
- [x] **3.16** Builder's Guild NPC stub.

## 4.00 Overworld Builds
- [x] **4.01** Hearthveil overworld build.
- [x] **4.02** Ember Hollow overworld build.
- [x] **4.03** All 7 realm overworlds built.
- [x] **4.04** Portal unlock logic.
- [x] **4.05** Embral Trials stubs.
- [x] **4.06** Trial portal markers.

## 5.00 Creature System
- [x] **5.01** Wisp data system.
- [x] **5.02** Pet data system.
- [x] **5.03** Companion data system.
- [x] **5.04** Player profile data class.
- [x] **5.05** Wisp roster manager.
- [x] **5.06** Wisp encounter system.
- [x] **5.07** Wisp entity (overworld).
- [x] **5.08** Wire Wisp Slot 1.
- [x] **5.09** Pet minigame stub.
- [x] **5.10** Pet sanctuary scene.
- [x] **5.11** Wisp capture flow.
- [x] **5.12** Companion party management.

## 6.00 Embral's Trials
- [x] **6.01** Heart Trial.
- [x] **6.02** Word Surge.
- [x] **6.03** Forge Gauntlet.
- [x] **6.04** Vault Challenge.
- [-] **6.05** Life Lodge and Creation Crucible stubs (DEFERRED).
- [x] **6.06** Trial unlock gates.

## 7.00 Creature Battle System
- [x] **7.01** Wisp Battle UI and Manager.
- [ ] **7.02** Wisp Battle Abilities implementation.
- [ ] **7.03** Battle SFX/VFX.
- [ ] **7.04** Educational Check Engine.

## 8.00 Family Systems
- [ ] **8.01** Nightly Review.
- [ ] **8.02** Raid Point System.
- [ ] **8.03** Family Raid Manager.
- [ ] **8.04** Family Raid Shop.
- [ ] **8.05** Mini-game Manager.
- [ ] **8.06-8.11** Minigame implementations.

## 9.00 Hardware Integrations
- [ ] **9.01** PS5 DualSense.
- [ ] **9.02** Wii Hardware.
- [ ] **9.03** Home Assistant.
- [ ] **9.04-9.07** IoT/Pi/Arduino support.

## 10.00 Parent Dashboard
- [ ] **10.01** PIN Security.
- [ ] **10.02** Quest Completion Analytics.
- [ ] **10.03** Emotional Check-in History.
- [ ] **10.04** Realm XP/Mastery Charts.
- [ ] **10.05** Session Timeline.

## 11.00 Ops / Observability
- [ ] **11.01** Error Logging.
- [ ] **11.02** Telemetry.
- [ ] **11.03** Replayable Tests.
- [ ] **11.04** CI/CD.

## 12.00 Final Hardening
- [ ] **12.01** Core progression loop audit.
- [ ] **12.02** Ascension mechanic.
- [ ] **12.03** Stress tests.
- [ ] **12.04** Accessibility.

## 13.00 Release Hardening
- [ ] **13.01** Release Candidate Freeze.
- [ ] **13.02** Smoke tests.
- [ ] **13.03** Full Loop Verification.
- [ ] **13.04** Final Release Scorecard.
