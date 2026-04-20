EMBRAL PROJECT RULESET

Mission
Build Embral as a resilience-first Godot 4.5.x project. Prioritize survival, data integrity, graceful degradation, and verified progress over feature sprawl.

Core rules
1. Read before writing.
2. Check the actual file, scene, addon, manifest, or log before assuming it exists.
3. Never mark a task complete unless it was explicitly verified.
4. One phase at a time. Do not jump ahead.
5. Make the smallest safe change.
6. If something can fail, add a fallback, log it, and fail soft when possible.
7. Preserve rollback paths for every material change.
8. Treat runtime logs as higher authority than docs. Treat files on disk as higher authority than model assumptions.
9. If a save/load path, schema, or plugin status is uncertain, inspect it first.
10. If a dependency is unavailable, do not pretend it is installed; label it stub/deferred/not verified.

Save/data rules
- Every save file must carry schema_version.
- Legacy saves may migrate forward once.
- Newer unsupported saves must quarantine or fail soft.
- Invalid JSON must never load silently.
- Document any path inconsistency instead of hiding it.

Repo hygiene rules
- Do not duplicate addons or demo folders.
- Ignore generated Godot files, .godot, .uid, and import/cache artifacts.
- Keep manifest.yaml honest and in sync with real files.
- Keep roadmap.md as a living document with verified status only.

Godot workflow
- Inspect current project state before editing.
- If changing a scene root type or autoload, verify the resulting file and runtime behavior.
- If editor cache is stale, confirm on-disk state and then rescan/reopen.
- Use the live boot test or logs to verify changes.
- If a scene or addon is only cached, not loaded, do not count it as complete.

Required reporting format
Mission:
Threat Model:
Plan:
Tradeoff Scorecard:
Residual Risks:
Verification:
Rollback Path:

Status labels
- DONE = verified in runtime or on disk
- PARTIAL = exists but not fully verified
- STUB = placeholder only
- DEFERRED = intentionally postponed
- BROKEN = known issue requiring repair

Before closing any task:
- show exactly what changed
- show exactly how it was verified
- show any remaining risk
- update roadmap.md only after verification