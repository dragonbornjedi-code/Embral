# Embrace — Session Log
# Updated at the END of every AI session. Never skip this.
# This file is the shared memory between AI sessions.
# Last updated: 2026-04-21

---

## CURRENT STATE

**Phase:** 2.00 Reliability — Active
**Godot version:** 4.5.stable.official.876b29033

---

## WHAT HAPPENED THIS SESSION

- **Massive Cleanup & Reorganization:**
    - Emptied `embral_drop` (temp folder) and moved all assets/scenes to canonical locations.
    - Moved audio files to `assets/audio/`.
    - Moved models to `assets/models/`.
    - Moved textures/shaders to `assets/textures/`.
    - Moved UI scenes to `scenes/ui/`.
    - Moved Hearthveil buildings to `scenes/overworld/hearthveil/`.
    - Created `scenes/npcs/`, `scenes/player/`, and `scenes/entities/` and moved respective scenes there.
    - Moved `gold-standard-quests.json` to `data/quests/hearthveil/`.
- **Startup Error Fixes:**
    - Verified `project.godot` is free of banned SQLite references.
    - Deleted `addons/demo/` (LimboAI demo content) via `git rm` to resolve preload/parse errors.
    - Removed `scripts/autoloads/sqlite_stub.gd` as per Law 3.
- **Main Menu Fixes:**
    - Fixed `@onready` parse errors in `scripts/ui/main_menu.gd`.
    - Rebuilt `scenes/ui/main_menu.tscn` with a clean node structure (Control > CenterContainer > VBoxContainer).
- **Verification:**
    - Verified clean headless boot with `godot --headless --check-only`.
- **Documentation Updates:**
    - Updated `manifest.yaml` with all moved files and asset registrations.
    - Updated `docs/roadmap.md` marking Phase 1 cleanup and 2.01 as DONE.
    - Updated `docs/compatibility.md` reflecting SQLite removal and `addons/demo/` deletion.

---

## WHAT TO DO NEXT (Phase 2 Focus)

1. **Verify end-to-end flow:** Boot → Main Menu → Profile Select (yet to be built).
2. **Implement Profile System (2.03):** Create, select, and delete player profiles in `user://save/{profile_id}/`.
3. **Implement PlayerProfile Data Class (2.04):** Level, XP, gold, etc.
4. **Continue Hearthveil Hub setup:** Navigable white-box with portal placeholders.

---

## FILES MODIFIED THIS SESSION
- `manifest.yaml`
- `project.godot`
- `scripts/ui/main_menu.gd`
- `scenes/ui/main_menu.tscn`
- `docs/roadmap.md`
- `docs/compatibility.md`
- `docs/SESSION.md`
- Numerous files moved from `embral_drop/` to canonical locations (see git status).

---

## KNOWN ISSUES (running list)

| Issue | Severity | File | Status |
|-------|----------|------|--------|
| Dialogic timeline end-to-end untested | MEDIUM | scripts/autoloads/dialogic_stub.gd | OPEN |
| SaveManager/QuestManager persistence split | LOW | scripts/autoloads/save_manager.gd | OPEN |
| Dialogic shutdown noise in headless (non-blocking) | LOW | addons/dialogic | KNOWN/ACCEPTED |
