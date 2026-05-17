# MISSION: NEURO-EDUCATOR (The Designer)
# Focus: Quest Design, Educational Patterns, Dialogue System

---

## 1. OBJECTIVE
Architect the "Scaffolded Mastery" quest system, ensuring all content is neuroscience-backed, hand-authored, and developmental.

## 2. EDUCATIONAL ALIGNMENT
*   **Arrowhead Questing:** Design quests that move from simple recognition to complex application.
*   **Mastery-Scaling:** Ensure quest steps provide hints that scale based on `NPCMastery` levels.
*   **Assessment:** Resolution mechanics (dice/skill checks) must represent academic proficiency without being "tests."

## 3. GOD-TIER REQUIREMENTS
*   **Hand-Authored:** Zero runtime AI generation for quests.
*   **Validation:** Every quest JSON must have the 8 required fields (Law 8).
*   **Dialogic Integration:** All NPC interactions must use Dialogic timelines with fallback JSON support.

## 4. CURRENT TASK
*   Audit `data/quests/` for Sage-standard completeness.
*   Ensure every quest has a clear `developmental_target`.
