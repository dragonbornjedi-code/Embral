# Dependency & Compatibility Matrix

> Last updated: 2026-04-20 — audited against runtime and files on disk.

| Dependency | Version | Status | Notes |
|------------|---------|--------|-------|
| Godot Engine | 4.5.stable.official.876b29033 | **Verified Runtime** | Verified with `godot --version` and headless project boot on 2026-04-20. |
| godot-ai (MCP) | 1.1.0 | **Installed** | Editor plugin present in `addons/godot_ai/` and enabled in `project.godot`. |
| LimboAI | 1.6.0 | **Runtime-Verified** | `addons/limboai/` present; probe confirms `BehaviorTree`, `LimboState`, and `LimboHSM` are registered. |
 | SQLite binding | `addons/sqlite3` | **Active** | Fully integrated and active. Directly exposes `Sqlite3Wrapper` at runtime and passes `CREATE TABLE`, `INSERT`, and `SELECT` verification.
 | Dialogic 2 | 2.0-Alpha-19 (Godot 4.4+) | **Active** | Plugin present and enabled. `DialogicStub` correctly detects the plugin and uses fallback dialogue when needed. Timeline integration pending.
| Phantom Camera | TBD | **Pending (2.01)** | 3D camera state transitions. Low blast radius — install when realm scenes begin. |

## Build Environment
- **OS:** Linux
- **Architecture:** x86_64
- **Rendering:** Forward+ (Mobile fallback support intended)
- **Git Repo:** dragonbornjedi-code/embral
- **Restore Tag:** `v0.00-foundation-pre-work` (commit 1466890)

## Phase 0.00 Status — Audited
- [x] Exact runtime build recorded from a live `godot --version` check
- [x] Git restore-point tag `v0.00-foundation-pre-work` created
- [x] `docs/source_of_truth.md` written
- [x] `docs/compatibility.md` (this file) active
- [x] `docs/naming_conventions.md` written
- [x] Boot scene (`scenes/boot.tscn`) + health check script active and headless-boot verified
- [x] EventBus autoload fully implemented
- [x] SaveManager with schema_version=1 and soft-fail quarantine
- [x] Test sandbox and test house both exist and instantiate cleanly

## Known Issues / Current Integrity Gaps
- `SaveManager` uses `user://save_game.json` while `QuestManager` separately writes `user://save/npc_mastery.json`. Persistence remains split.
- `addons/demo/` contains LimboAI demo content whose internal references still point at `res://demo/...`, so it is not cleanly usable from its current repo location.
- Headless exit still reports Dialogic-owned leaked resources and orphan nodes during shutdown. Runtime boot and SQLite integration pass, but Dialogic teardown appears noisy in this environment.
- Dialogic timelines are not yet integrated into gameplay.
