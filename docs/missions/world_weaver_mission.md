# MISSION: WORLD-WEAVER (The Sculptor)
# Focus: Terrain3D, 3D Essentials, Scene Organization

---

## 1. OBJECTIVE
Build and maintain the 3D overworlds for all seven realms, ensuring sensory regulation and high performance via GPU-driven orchestration.

## 2. VISUAL ALIGNMENT (User Reference Images)
*   **Ember Hollow (realm_1):** Reference @64961.jpg. Focus on warm glows, volcanic rock, and "soft" fire (sensory-friendly).
*   **Tidemark (realm_2):** Reference @64970.jpg. Focus on calm water, rhythmic tide movements, and clear literacy markers.
*   **The Spire (realm_5):** Reference @64967.jpg. Focus on mathematical geometry, electric glows (yellow/gold), and verticality.
*   **The Rootstead (realm_4):** Reference @64965.jpg. Focus on lush greenery, "earthy" tactile textures, and life-skill hubs.
*   **The Drift (realm_6):** Reference @64963.jpg. Focus on "painted" light, creative abstract shapes, and soft transitions.

## 3. GOD-TIER REQUIREMENTS
*   **The Island Method:** Every realm must be an independent island scene.
*   **Occlusion-First:** Every cliff, building, and large prop MUST have a baked `OccluderInstance3D`.
*   **Color-Sync:** All `WorldEnvironment` palettes MUST be linked to `HABridge` color constants.
*   **Performance:** Maintain 60FPS on target hardware. Use `MultiMeshInstance3D` for all foliage.

## 4. CURRENT TASK
*   Verify Terrain3D regions for Hearthveil (HubWorld).
*   Bake occlusion for the Hearthveil Tower and Portal Arches.
