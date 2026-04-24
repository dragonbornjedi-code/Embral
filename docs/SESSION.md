# Embral — Session Log
# Last updated: 2026-04-23

---

## CURRENT STATE

**Phase:** 3.00 NPC System — IN PROGRESS
**Godot version:** 4.5.stable.official.876b29033

---

## WHAT WAS VERIFIED THIS SESSION

- **Roadmap 3.11 (Fallback Dialogue):** Created 25 fallback dialogue JSON files (24 NPCs + Ignavarr) in `data/dialogue/`. All use `{player}` placeholder.
- **Roadmap 3.12 (Quest Index):** Created `data/quest_index.json` by parsing all quest files. Verified valid JSON.
- **Roadmap 3.13 (Ignavarr Script):** Created `scripts/npcs/teachers/ignavarr.gd`. Implemented quest gating and portal unlocking logic.
- **Registration:** All files registered in `manifest.yaml`.
- **System Integrity:** Verified via `godot --headless` (all core managers [OK]).

---

## NEXT TASK (start here)

Roadmap item 3.14 — NPC home preference side quests & Builder's Guild integration.

Implement:
1. `NPCHomeData` usage in NPC classes.
2. Building an interaction for the Builder's Guild NPC in Hearthveil.
3. Verify at least 3 NPCs have fulfillable home preferences.

---

## KNOWN ISSUES

| Issue | Severity | Status |
|-------|----------|--------|
| Quest loading warnings in headless log (gold-standard-quests.json) | LOW | INVESTIGATING |
| HUD XP bar max_value is hardcoded to 100 | LOW | PENDING LVL SYSTEM |
| Emotional check-in timer runs in background always | LOW | OPTIMIZE LATER |
