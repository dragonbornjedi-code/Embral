# Embral — Session Log
# Updated at the END of every AI session. Never skip this.
# This file is the shared memory between AI sessions.
# Last updated: 2026-04-20

---

## CURRENT STATE

**Phase:** 1.00 Safety/Integrity — finishing up. Starting 2.00.
**Last verified working:** Boot scene loads cleanly. All 6 autoloads confirmed active.
**Godot version:** 4.5.stable.official.876b29033

---

## WHAT HAPPENED LAST SESSION

**Agent:** Windsurf + Claude
**Date:** 2026-04-20

### Done
- Boot scene fixed (Node2D → Node, deferred scene transition)
- LimboAI addons/demo/ folder REMOVED — was causing parse errors
- dialogic_stub.gd created — bridges real Dialogic timelines with JSON fallback
- save_manager.gd schema v1 with v0 migration
- test_sandbox.tscn and test_house.tscn verified loading in headless
- rewards.json v3.0 committed to data/items/

### Removed / Fixed
- `godot-sqlite` / `sqlite_stub.gd` REMOVED — was added by Windsurf without authorization. Was causing GDExtension startup errors. Not needed. Do not re-add.
- LimboAI demo paths were partially patched before we just deleted the demo folder instead

### Still Broken / Needs Verification
- Main menu: VBoxContainer parent path errors still present in headless output. `scenes/ui/main_menu.tscn` needs rebuild.
- Dialogic timeline integration: dialogic_stub.gd exists but no real timeline has been tested end-to-end with a test NPC.
- save_manager.gd write/read not verified in headless with explicit assertion output.
- quest_manager.gd not end-to-end tested with a real quest JSON.

---

## WHAT TO DO FIRST NEXT SESSION

**Priority 1 (fix broken things):**
1. Fix `scenes/ui/main_menu.tscn` — rebuild cleanly, no VBoxContainer errors in headless
2. Verify `save_manager.gd` write/read cycle in headless
3. Verify `quest_manager.gd` loads a real quest JSON and emits `quest_started`

**Priority 2 (start Phase 2):**
4. Begin 2.01 — main menu scene full rebuild
5. Begin 2.04 — PlayerProfile data class

**Do NOT start Phase 3 or later until 1.11-1.14 and 2.01-2.02 are verified DONE.**

---

## FILES MODIFIED THIS SESSION
- `scripts/autoloads/dialogic_stub.gd` — created
- `scripts/autoloads/save_manager.gd` — created
- `scripts/boot.gd` — fixed Node type and scene transition
- `scenes/boot.tscn` — fixed root node
- `scenes/overworld/hearthveil/test_sandbox.tscn` — added floor mesh and test_house instance
- `scenes/overworld/hearthveil/test_house.tscn` — created
- `addons/demo/` — DELETED
- `scripts/autoloads/sqlite_stub.gd` — DELETED
- `project.godot` — removed SqliteDB autoload entry
- `data/items/rewards.json` — updated to v3.0
- `AGENTS.md` — updated to v2.0
- `manifest.yaml` — updated to v2.0

---

## KNOWN ISSUES (running list)

| Issue | Severity | File | Status |
|-------|----------|------|--------|
| main_menu.tscn VBoxContainer errors | HIGH | scenes/ui/main_menu.tscn | OPEN |
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
