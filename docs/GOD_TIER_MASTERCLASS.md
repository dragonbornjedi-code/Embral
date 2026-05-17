# EMBRAL GOD-TIER MASTERCLASS: Experimental Meanings & Patterns
# This document defines the "Genius Level" standards for Embral development.
# Use these patterns to override standard gamedev assumptions.

---

## 1. THE EXPERIMENTAL MEANINGS

### A. 3D-ESSENTIALS = "SENSORY-REGULATED ORCHESTRATION"
*   **The Meaning:** 3D worlds are not just "scenes"; they are sensory environments for children with varying regulation needs.
*   **God-Tier Pattern:** 
    *   **Color-Sync:** Every realm's color palette (defined in `HABridge`) must drive the `WorldEnvironment` and real-world lights.
    *   **Occlusion-First:** All 3D meshes must be occluded by baked `OccluderInstance3D` to maintain 60FPS on target hardware.
    *   **Distance-Culling:** Use `VisibilityRange` (HLOD) to swap complex educational props for simplified "lore-markers" at distance.

### B. AI-NAVIGATION = "EDUCATIONAL SCAFFOLDING (LIMBOAI)"
*   **The Meaning:** AI is not a combatant; it is a developmental scaffold.
*   **God-Tier Pattern:** 
    *   **Hybrid HSM+BT:** 
        *   `HSM`: Manage "Energy Levels" and "Focus States" (Sleepy, Alert, Playful).
        *   `BT`: Handle "Scaffolded Assistance" (Give Hint -> Show Pattern -> Let Player Try).
    *   **Mastery-Scaling:** The BT `Tick` must read `NPCMastery.get_current_level()` to adjust response speed and hint complexity.

### C. SCENE-ORGANIZATION = "THE MODULAR REALM (ISLAND METHOD)"
*   **The Meaning:** The world is a library of "Learning Islands."
*   **God-Tier Pattern:**
    *   **Process-Gating:** Use `Area3D` boundaries to toggle `process_mode = DISABLED` for entire realm chunks.
    *   **Resource-Injection:** All interactive props (Crystals, Pedestals) must be injected with `QuestStep` resources at runtime via `QuestManager`.

---

## 2. THE MULTI-AGENT ORCHESTRATION (THE EMBRAL COUNCIL)

To build with "God-tier" consistency, we dispatch specialized agents:

1.  **ARCHITECT-IGNAVARR (The Guardian):**
    *   **Role:** Enforces `AGENTS.md` Laws.
    *   **Skill focus:** `godot-master`, `godot-project-setup`.
    *   **Task:** Roadmap management and final PR validation.

2.  **WORLD-WEAVER (The Sculptor):**
    *   **Role:** Builds the environment and streaming systems.
    *   **Skill focus:** `terrain_3d`, `3d-essentials`, `godot-optimization`.
    *   **Task:** Realm creation, occlusion baking, lighting synchronization.

3.  **LIFE-SCULPTOR (The Animator):**
    *   **Role:** Animates characters and rigs educational interactions.
    *   **Skill focus:** `animation-system`, `physics-system`, `blender-pipeline`.
    *   **Task:** Rigging NPCs, creating "celebration" animations, haptic feedback design.

4.  **NEURO-EDUCATOR (The Designer):**
    *   **Role:** Architects the educational flow.
    *   **Skill focus:** `quest-design`, `educational-patterns`, `dialogue-system`.
    *   **Task:** Writing hand-authored quests, Dialogic timelines, and scaffolding logic.

5.  **AI-MIND-MAKER (The Strategist):**
    *   **Role:** Builds the "Adaptive Mentor" logic.
    *   **Skill focus:** `limboai`, `state-machine`, `npc-mastery`.
    *   **Task:** HSM+BT design, blackboard data mapping, difficulty scaling.

6.  **HARDWARE-TINKER (The Bridge):**
    *   **Role:** Integrates the physical world.
    *   **Skill focus:** `ha-bridge`, `hardware-manager`, `dual-sense-haptics`.
    *   **Task:** ESP32/Arduino integration, HABridge logic, Wii Balance Board calibration.

---

## 3. ADVANCED GODOT 4.6+ HACKS (THE "TRICKS")

*   **The "Jolt" Swap:** Always use Godot Jolt for 3D physics. Default GodotPhysics 3D is "Stub-tier" for large heightmaps.
*   **The "Thread-Safety" Guard:** Never modify the `SceneTree` from a `WorkerThreadPool` task. Use `call_deferred()` or a `Signal` back to the main thread.
*   **The "Double-Precision" Buffer:** For The Spire and The Drift (high-altitude realms), ensure origin-shifting is active to prevent vertex jitter.
*   **The "Resource-Clone" Pattern:** When modifying item stats, always `.duplicate()` the Resource to avoid cross-pollinating all items of that type.
