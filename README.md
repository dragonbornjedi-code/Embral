# Embral

A local-first, open-source, neuroscience-backed educational RPG for children ages 4–8.

Built with Godot 4. Runs on a single device. No internet required. No accounts. No subscriptions.

---

## What Is Embral?

Embral is an educational RPG where children explore seven realms, each focused on a real developmental domain. They collect creatures called Wisps, raise pets, travel with Companions, complete hand-crafted quests grounded in child development research, and unlock their world as they grow.

The game is designed for neurodivergent-first accessibility, meaning it works well for all children and especially well for children who learn differently.

---

## The Seven Realms

| Realm | Domain |
|-------|--------|
| Hearthveil | Hub World — home base |
| The Ember Hollow | Social-Emotional Learning + Sensory Regulation |
| The Tidemark | Literacy, Language, Communication |
| The Forge Run | Physical Development — Gross + Fine Motor |
| The Rootstead | Life Skills + Independence |
| The Spire | Science, Nature, Math, Discovery |
| The Drift | Creative Arts, Music, Making, Imagination |

---

## Hardware

**Base game (keyboard + mouse) is complete on its own.**

Optional expansions add depth, never gate content:
- PS5 DualSense controller (haptic feedback, motion controls)
- Wii hardware (Balance Board, Wiimotes, Nunchucks, IR Camera)
- Home Assistant smart home integration
- ESP32 / Arduino gadgets
- Raspberry Pi integrations

---

## Creature System

**Wisps** — element-based battle companions. Up to 3 per character. Slot 1 Wisp follows you in the overworld. Seven types: Ember (Fire), Ripple (Water), Breeze (Wind), Mossy (Earth), Volt (Electric), Lumis (Light), Shade (Dark — dungeon only).

**Pets** — virtual pets that live at your house. Interactive mini-game. Passive bonuses. No battles.

**Companions** — a second avatar. Player-named and customized. Can be controlled by a second player for co-op. One travels with you at a time.

---

## Quest Design Philosophy

Every quest in Embral is hand-authored. No AI generation at runtime.

Each quest is grounded in at least one of:
- Vygotsky's Zone of Proximal Development
- Self-Determination Theory (Deci & Ryan)
- Polyvagal Theory (Porges)
- Spaced Repetition
- Narrative Context for Memory (Willingham)
- Multi-Sensory Encoding

Every quest has: a developmental target, scaffolding for when children get stuck, no punishment for failure, and an NPC who needs the child's help (not the other way around).

---

## Parent Dashboard

Accessible from the main menu (PIN-gated). Tracks:
- Quest completion and XP per realm
- NPC mastery levels per subcategory
- Emotional check-in history
- Response patterns (thinking vs. guessing)
- Strengths and areas for growth across all developmental domains
- Teaching style effectiveness comparison

---

## Technical Stack

- **Engine:** Godot 4
- **Language:** GDScript
- **Dialogue:** Dialogic 2
- **Save system:** Local `user://` directory only
- **No backend:** No server, no AI calls at runtime, no cloud
- **License:** MIT

---

## For Contributors

Read `AGENTS.md` before touching anything in this repo. It contains the full rule set for file structure, naming, hardware patterns, and what is strictly forbidden.

Read `manifest.yaml` before creating any file. If it is not registered there first, it does not belong here.

---

## Status

🔨 **Foundation phase** — Directory structure and core architecture being established.

---

## License

MIT — see `LICENSE` file.
