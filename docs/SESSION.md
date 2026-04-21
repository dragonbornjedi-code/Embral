# Embral — Session Log
# Updated at the END of every AI session. Never skip this.
# This file is the shared memory between AI sessions.
# Last updated: 2026-04-20

---

## CURRENT STATE

**Phase:** 2.00 Reliability — Active (Correcting course: Phase 2 is required before Phase 3)
**Godot version:** 4.5.stable.official.876b29033

---

## WHAT HAPPENED THIS SESSION

- Snapshot commit of `project.godot` and `main_menu.tscn`.
- Finalized removal of `addons/sqlite3/` (the banned SQLite dependency).
- Integrated new asset packs (terrain_3d, demo assets).
- Updated SESSION.md log.

---

## WHAT TO DO NEXT (Phase 2 Focus)

1. **2.01:** Fix `scenes/ui/main_menu.tscn` (rebuild, resolve VBoxContainer errors).
2. **2.02:** Main menu UI implementation (white-box).
3. **2.03:** Profile system implementation.
4. **2.04:** Implement `PlayerProfile` data class.

**Current Session Constraints:**
- Phases 3+ are BANNED until Phase 2 completion and verification.
- Focus strictly on implementing 2.00-2.20 systems.
- Every new script must be registered in `manifest.yaml` before creation.
- Maintain `docs/SESSION.md` and update `docs/roadmap.md` on progress.

---

## FILES MODIFIED THIS SESSION
- `docs/SESSION.md` — status update
- `addons/sqlite3/` — deleted
- `addons/terrain_3d/` — added
- `demo/` — added
- `icon.png` — added

---

## KNOWN ISSUES (running list)

| Issue | Severity | File | Status |
|-------|----------|------|--------|
| main_menu.tscn VBoxContainer errors | HIGH | scenes/ui/main_menu.tscn | VERIFIED |
| Dialogic timeline end-to-end untested | MEDIUM | scripts/autoloads/dialogic_stub.gd | OPEN |
| save_manager headless verification missing | MEDIUM | scripts/autoloads/save_manager.gd | OPEN |
| quest_manager headless verification missing | MEDIUM | scripts/autoloads/quest_manager.gd | OPEN |
| Dialogic shutdown noise in headless (non-blocking) | LOW | addons/dialogic | KNOWN/ACCEPTED |

---

## HARDWARE STATUS ON EZRA'S MACHINE
- PS5 DualSense: DETECTED (joy_id=0 on startup — confirmed in boot log)
- Wii hardware: NOT detected (xwiimote not installed yet)
- HA Green: NOT configured (ha_url not set in config)
- ESP32/Arduino/Pi: NOT detected

---

## ADDON VERSIONS
- LimboAI: 1.6.0 (runtime verified — BehaviorTree, LimboState, LimboHSM registered)
- Dialogic 2: 2.0-Alpha-19 (on disk, enabled, partially verified)
- godot_ai MCP plugin: 1.1.0 (active, server on port 8000)
