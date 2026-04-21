# Embral Project Roadmap (Resilience-First)

> **Living Document:** This roadmap tracks the sequential progress of Embral's development. Each step must be completed, tested, and verified before proceeding to the next.

## Status Summary
- **Current Phase:** 1.00 Safety/Integrity — IN PROGRESS
- **Godot Version:** 4.5.stable.official.876b29033
- **Last Sync:** 2026-04-20

---

## 0.00 Foundation
- [x] **0.01** Record the verified Godot 4.5.x runtime build and actual addon/plugin versions. Runtime verified at `4.5.stable.official.876b29033`.
- [x] **0.02** Create Git backup and restore point before major changes.
- [x] **0.03** Define source-of-truth hierarchy (Logs > Disk > Docs > Models).
- [x] **0.04** Create `res://docs/compatibility.md` for dependency tracking.
- [x] **0.05** Create minimal "boot scene" (`scenes/boot.tscn`) for health checks.
- [x] **0.06** Finalize global `EventBus` for quest, UI, realm, and hardware.
- [x] **0.07** Establish naming conventions for realms, NPCs, and quests.
- [x] **0.08** `test_sandbox.tscn` and `test_house.tscn` both exist, instantiate cleanly, and the sandbox now includes a visible floor mesh plus the test house instance.

## 1.00 Safety/Integrity
- [x] **1.01** LimboAI v1.6.0 is on disk and runtime-verified. Probe confirms `BehaviorTree`, `LimboState`, and `LimboHSM` classes are registered.
- [x] **1.02** SQLite binding at `addons/sqlite3/gdext.gdextension` is fully integrated. Directly exposes `Sqlite3Wrapper` at runtime and passes `CREATE TABLE`, `INSERT`, and `SELECT` verification.
- [x] **1.03** Dialogic 2 v2.0-Alpha-19 is on disk, enabled in `project.godot`, and runtime-verified. `DialogicStub` correctly detects the plugin and uses fallback dialogue when needed. Timeline integration pending.
- [x] **1.04** Schema/version checks in `SaveManager` (v1) and `QuestManager` NPC mastery (v1). Legacy v0 migrates. Future versions quarantined.
- [x] **1.05** Quest JSON validation: all 8 required fields checked on load. Missing fields logged and rejected.
- [x] **1.06** Content quarantine: invalid quest files logged with reason, not loaded.
- [x] **1.07** Fallback dialogue: `DialogicStub` returns fallback line when Dialogic missing or file absent.
- [x] **1.08** Safe Mode: `HABridge._safe_mode` reads `ha_safe_mode` from config. All HA methods guarded.
- [x] **boot fix** `boot.gd` and `boot.tscn` root changed from `Node2D` to `Node`, main menu parenting was corrected, and deferred scene change removed the boot-time scene transition error in a headless run.

## 2.00 Reliability/Performance
- [ ] **2.01** Integrate **Phantom Camera** for 3D state transitions.
- [ ] **2.02** Build modular house scenes (shell, roof, door, decor).
- [ ] **2.03** Implement town slot placement for houses.
- [ ] **2.04** Implement streamed interior sub-scenes.
- [ ] **2.05** Unify realm transition system across all 6 portals.
- [ ] **2.06** Set hard limits for NPC, active quest, and interior counts.
- [ ] **2.07** Build loading guards for heavy AI/asset operations.
- [ ] **2.08** Integrate modular medieval asset packs.

## 3.00 Ops/Observability
- [ ] **3.01** Add structured logging for all major systems.
- [ ] **3.02** Add metrics counters for failed loads and fallbacks.
- [ ] **3.03** Create debug overlay for realm/quest/persistence status.
- [ ] **3.04** Create replayable test sequences for core flows.
- [ ] **3.05** Implement MCP/Gemini orchestration health checks.
- [ ] **3.06** Record plugin version hashes/tags in project docs.
- [ ] **3.07** Establish "Last Good Build" git tag protocol.
- [ ] **3.08** Capture runtime warnings to dedicated forensic log.

## 4.00 Final Hardening
- [ ] **4.01** Implement core Dark Cloud-style loop.
- [ ] **4.02** Refine smooth modular building interactions.
- [ ] **4.03** Implement realm-specific rule logic.
- [ ] **4.04** Implement smart-home hardware circuit breakers.
- [ ] **4.05** Ensure all external integrations are optional/logged.
- [ ] **4.06** Stress-test corrupted data and missing assets.
- [ ] **4.07** Implement save migration automated tests.
- [ ] **4.08** Implement "Fail Closed" minimal boot mode.

## 5.00 Release Hardening
- [ ] **5.01** Freeze milestone build and tag in Git.
- [ ] **5.02** Execute full smoke test suite (Movement, Dialogue, UI, Saving).
- [ ] **5.03** Confirm 100% editor-free completion of one full loop.
- [ ] **5.04** Finalize internal testing documentation.
- [ ] **5.05** Separate AI tooling branch from stable runtime.
- [ ] **5.06** Finalize recovery playbook.
- [ ] **5.07** Audit all subsystem verification states.
- [ ] **5.08** Final release scorecard approval.
