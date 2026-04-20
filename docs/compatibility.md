# Dependency & Compatibility Matrix

> Last updated: 2026-04-20 — Phase 0.00 Foundation complete.

| Dependency | Version | Status | Notes |
|------------|---------|--------|-------|
| Godot Engine | 4.5.2 | **Target** | Recommended maintenance release. Pin this. Do not upgrade without a new restore-point tag. |
| godot-ai (MCP) | 0.2.0 | **Installed** | Integrated AI development plugin. Lives in `addons/godot_ai/`. |
| LimboAI | 4.4–4.5 build | **Pending (1.01)** | NPC state machines and behavior trees. Install before any NPC work. |
| Godot-SQLite | 4.x | **Pending (1.02)** | Persistent quest state and parental tracking. Install before save system expansion. |
| Dialogic 2 | TBD | **Pending (1.03)** | Dialogue system. Verify distribution path before depending on it — Asset Library parity unconfirmed. |
| Phantom Camera | TBD | **Pending (2.01)** | 3D camera state transitions. Low blast radius — install when realm scenes begin. |

## Build Environment
- **OS:** Linux
- **Architecture:** x86_64
- **Rendering:** Forward+ (Mobile fallback support intended)
- **Git Repo:** dragonbornjedi-code/embral
- **Restore Tag:** `v0.00-foundation-pre-work` (commit 1466890)

## Phase 0.00 Status — All items complete
- [x] Godot 4.5.2 locked in `project.godot`
- [x] Git restore-point tag `v0.00-foundation-pre-work` created
- [x] `docs/source_of_truth.md` written
- [x] `docs/compatibility.md` (this file) active
- [x] `docs/naming_conventions.md` written
- [x] Boot scene (`scenes/boot.tscn`) + health check script active
- [x] EventBus autoload fully implemented
- [x] SaveManager with schema_version=1 and soft-fail quarantine
- [x] Test sandbox stub (`scenes/overworld/hearthveil/test_sandbox.tscn`)

## Known Issues / Deferred to 1.04
- `SaveManager` uses `user://save_game.json` but `manifest.yaml` defines `user://save/player_profile.json`. Save paths need unification in Phase 1.04.
- `QuestManager` saves NPC mastery to `user://save/npc_mastery.json` independently of `SaveManager`. These should be consolidated.
