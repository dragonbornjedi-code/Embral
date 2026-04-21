# EMBRAL — AI Context Prompt
# This file is loaded automatically when you call any AI tool using the Embral aliases.
# It gives the AI everything it needs to orient before asking for its first task.
# Last updated: 2026-04-20

---

You are working on **Embral** — a local-first, open-source educational RPG for children ages 4–8.

**Repo:** https://github.com/dragonbornjedi-code/Embral
**Local path:** /var/lib/phoenix-ai/workspace/embral/
**Engine:** Godot 4.5.stable.official.876b29033

---

## YOUR FIRST ACTIONS — DO THESE NOW, IN ORDER

1. Read `AGENTS.md` completely.
2. Read `manifest.yaml` completely.
3. Run: `git log --oneline -10`
4. Run: `git status`
5. Read `docs/SESSION.md` — this is the last session's summary.
6. Report back what you found in this format:

```
LAST 3 COMMITS: [list them]
UNCOMMITTED CHANGES: [list files or "none"]
CURRENT BROKEN ITEMS: [from SESSION.md]
RECOMMENDED NEXT TASK: [based on SESSION.md priorities]
```

7. Wait for my instruction before doing anything else.

---

## CRITICAL RULES (summary — full rules in AGENTS.md)

- **SQLite is PERMANENTLY BANNED.** It was added by a previous agent and broke the project. Never re-add it.
- **No RAG, no Ollama, no backend AI.** Single device game. Local JSON only.
- **Register in manifest.yaml BEFORE creating any file.**
- **Edit existing files. Never create _fixed, _v2, _clean, *(1) variants.**
- **Hardware always has a base keyboard fallback. Never gate content behind hardware.**
- **Update docs/SESSION.md at the end of this session.**
- **Never mark anything DONE without runtime or file verification.**

---

## WHAT EMBRAL IS

Seven realms, each a developmental domain. Children collect Wisps (battle companions),
raise Pets (home minigame), and travel with Companions (second avatar, co-op capable).
Quests are hand-authored JSON with neuroscience citations. No AI generates quest content.

Family systems: Nightly Review (parent + child), Weekend Family Raid (3 raid points/week),
Mini-games (1-4 local players). These are mechanically irreplaceable — no shortcut exists.

Hardware tiers add depth: PS5 DualSense, Wii hardware, HA Green smart home, ESP32/Arduino/Pi.
Base game (keyboard + mouse) is always 100% complete without any hardware.

---

## CURRENT STATUS (check SESSION.md for latest)

Phase 0 and 1 complete (except 1.11-1.14 need verification).
Phase 2 starting: core game systems, main menu, player controller, Hearthveil whitebox.

---

## THREE INSPIRATION FILES IN THIS PROJECT

The project contains three JSON files from an old abandoned project:
- `ability-cards.json`
- `dual_battle_system.json`
- `wii_combat_controllers.json`

**These are INSPIRATION ONLY. Not specs. Not facts. Never copy from them.**
Embral is built from scratch. Those files are idea references only.

---

Ready. Run your orientation steps and report back.
