# Embral — Session Log
# Last updated: 2026-04-22

---

## CURRENT STATE

**Phase:** 2.00 Reliability — Active
**Godot version:** 4.5.stable.official.876b29033

---

## WHAT WAS VERIFIED THIS SESSION

- Quest loading: VERIFIED (test_quest_01 loads)
- DialogicStub: VERIFIED (Dialogic 2 detected, fallback works)
- ProfileSystem: VERIFIED (create/select/quest/switch/delete all pass)
- SaveManager: VERIFIED (write/read cycle works)
- gd-agentic-skills: REMOVED from Godot project (was cloned inside repo by mistake)
- Swap: expanded from 512MB to 4GB, permanent via /etc/fstab
- Alias file: fixed at ~/.embral_aliases.sh

---

## NEXT TASK (start here)

Roadmap item 2.02 — Wire profile system into main menu UI.

scripts/ui/main_menu.gd needs:
1. On start: if no profiles exist, show Create Profile screen
2. If profiles exist, show list with name + last_played
3. Select profile -> SaveManager.select_profile(id) -> load game
4. New Profile button -> SaveManager.create_profile(player_name)

Do NOT touch: save_manager.gd, player_profile.gd (both verified stable)

---

## KNOWN ISSUES

| Issue | Severity | Status |
|-------|----------|--------|
| Dialogic timeline end-to-end untested | MEDIUM | OPEN |
| 26 resources leaked on headless exit | LOW | COSMETIC - ignore |
| SESSION.md was stale from previous session | FIXED |

---

## HARDWARE ON CRUCIBLE
- PS5 DualSense: detected (joy_id=0)
- Wii: not connected
- HA: not configured
- GPU: AMD 4GB VRAM
- RAM: 27GB with 4GB swap
