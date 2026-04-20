# Embral Project Roadmap (Resilience-First)

> **Living Document:** This roadmap tracks the sequential progress of Embral's development. Each step must be completed, tested, and verified before proceeding to the next.

## Status Summary
- **Current Phase:** 0.00 Foundation
- **Godot Version:** 4.5.2
- **Last Sync:** 2026-04-20

---

## 0.00 Foundation
- [x] **0.01** Freeze runtime to Godot 4.5.2 and record exact build/plugin versions.
- [x] **0.02** Create Git backup and restore point before major changes.
- [x] **0.03** Define source-of-truth hierarchy (Logs > Disk > Docs > Models).
- [x] **0.04** Create `res://docs/compatibility.md` for dependency tracking.
- [x] **0.05** Create minimal "boot scene" (`scenes/boot.tscn`) for health checks.
- [x] **0.06** Finalize global `EventBus` for quest, UI, realm, and hardware.
- [x] **0.07** Establish naming conventions for realms, NPCs, and quests.
- [x] **0.08** Create test realm sandbox and test house.

## 1.00 Safety/Integrity
- [ ] **1.01** Install **LimboAI** (Godot 4.4–4.5 build).
- [ ] **1.02** Install **Godot-SQLite** for persistent state.
- [ ] **1.03** Install **Dialogic 2** (Verify distribution path).
- [ ] **1.04** Implement schema/version checks for save records. *(SaveManager schema_version added in 0.00 — full multi-file migration system still needed here.)*
- [ ] **1.05** Create validation wrappers for imported data manifests.
- [ ] **1.06** Implement content quarantine for invalid data.
- [ ] **1.07** Implement fallback dialogue for missing timelines.
- [ ] **1.08** Add "Safe Mode" circuit breaker for smart-home integration.

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
