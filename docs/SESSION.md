# Embral — Session Log
# Last updated: 2026-05-13

---

## CURRENT STATE
**Phase:** 13.05 MVP entry slice — launcher, avatar flow, Hearthveil portals

## WHAT WAS DONE THIS SESSION
- Fixed invalid local Codex skill metadata outside the repo:
  `/home/joshuar/.agents/skills/typescript-e2e-testing/SKILL.md`
- Replaced the overlong skill frontmatter `description` with a 308-character summary.
- Replaced trademarked collectible content with original Embral `EmberSigil` content.
- Fixed `PlayerProfile.from_dict()` typed-array migration so saved profiles can be selected.
- Verified the real main-menu create-profile flow reaches `HubWorld`.
- Added visible Hearthveil first-step guidance: collect 3 spark coins, then talk to Ignavarr.
- Wired coin and XP rewards into `SaveManager` so collection/progress changes local profile state.
- Added real GLB model instances to Hearthveil: generic dragon, fantasy tower, medieval buildings, owl guide, and portal crystals.
- Added six visible realm portals from Hearthveil to Ember Hollow, Tidemark, Forge Run, Rootstead, The Spire, and The Drift.
- Added WASD/arrow/D-pad/left-stick input mappings for base keyboard and generic/PS5-style controllers.
- Runtime-verified `SaveManager` persists reward changes by creating, reloading, and deleting a temp profile.
- Removed unused style-referenced baby dragon asset files from `assets/models/`.
- Confirmed local runtime is Godot `4.6.2.stable.official.71f334935` and updated stale 4.5 docs.
- Replaced a real LAN printer IP in `3d_prints/infinity_cube/INSTRUCTIONS.md` with a placeholder.
- Registered active HubWorld support files and enabled editor plugins in `manifest.yaml`.
- Added `AvatarCreator.tscn` flow: new profile now opens character creation, stores hero name/color/style, then loads Hearthveil.
- Added a `Play Embral` desktop launcher at `/home/joshuar/Desktop/PlayEmbral.desktop` and registered it in the local applications menu.
- Validated the desktop launcher with `desktop-file-validate`.
- Attached a shared realm controller to all six overworld realm scenes so each loads with a player, HUD objective, four NPC guides, and a return portal to Hearthveil.
- Fixed realm scene parse errors by moving sub-resources before node references and correcting Godot 4 color constructors.
- Fixed generated realm return portals so their script initializes after required label/area children exist.
- Runtime-verified all six realm scenes load under Godot 4.6.2 without parse or script errors.
- Runtime-verified avatar creation creates/selects an Ezra profile, transitions to Hearthveil, and cleans up the test profile.
- Re-ran copyright/IP scans; no banned copyrighted/trademarked strings or hardcoded forbidden IPs were found outside policy guardrails.
- Imported KayKit Adventurers Character Pack useful source content under `assets/models/kaykit_adventurers/`.
- Verified KayKit license is CC0 and kept `LICENSE.txt` with the imported assets.
- Wired KayKit character GLBs into avatar creation preview and the runtime player model.
- Imported every model from the pack's `Assets/gltf` item folder into `assets/models/kaykit_adventurers/items/`; skipped duplicate texture-only folders from the zip.
- Runtime-verified 32 KayKit model resources load in Godot.
- Godot now detects the connected PS5 DualSense as joypad 0, hardware tier 1.
- Confirmed Ubuntu package name is not `wiimote`; available packages include `xwiimote`, `wminput`, and `lswm`.
- Rewired new-profile flow so avatar creation loads the tutorial scene (`scenes/overworld/Main.tscn`) instead of skipping directly to Hearthveil.
- Rewired existing profile selection so incomplete profiles resume tutorial and completed profiles continue to Hearthveil.
- Added `scripts/world/tutorial_manager.gd` to run the authored Hearthveil tutorial quest.
- Extended `hv_ignavarr_tutorial_01` with the final return-to-Ignavarr step.
- Tutorial now completes platform approach, coin collection, and Ignavarr interaction, marks `tutorial_completed`, grants quest rewards through `QuestManager`, saves the profile, and transitions to Hearthveil.
- Runtime-verified avatar creation reaches the tutorial scene.
- Runtime-verified tutorial completion marks the profile complete and transitions to HubWorld.
- Implemented the requested tutorial MVP route: Ignavarr intro, movement controls, portal destination tour, dungeon entrance shown as under maintenance, one starter NPC quest from each of the six realms, return to Ignavarr, house unlock, level 2 unlock, and first pet unlock.
- Runtime-verified the full tutorial flow with `/tmp/embral_full_tutorial_flow_check.gd`.
- Note: if the intended requirement is literally 21 quests per realm, that is not present; the repo currently has 8 authored quests per realm.
- Inspected `/home/joshuar/Downloads/Godot-MCP-Native-d8bc1838409294a22f8cd4cb5878d9a3b028e589.zip`; it appears MIT-licensed and usable in principle, but it conflicts with the existing `addons/godot_mcp/` addon path and was not installed.
- Inspected `/home/joshuar/Downloads/CLAUDE.md`; it is useful as policy/context, but stale versus the current Godot 4.6.2 repo state and should not override `AGENTS.md`, `manifest.yaml`, or this session log.
- Inspected `/home/joshuar/Downloads/SAGE_PERSONA.md`; current quest JSON files do not meet its full Sage quest-template standard.
- Checked Sage-template coverage: `0 / 50` quest JSON files contain one or more of the fuller Sage fields such as `deep_objectives`, `sensory_load`, `ef_demand`, `parent_notes`, `celebration`, or `extension`.
- Began scanning `/var/lib/phoenix-ai/workspace/legacy_quarantine_questaria` for reusable material. It contains quest/NPC/UI/save ideas, but also banned or unsafe material including Ollama/AI runtime references, hardcoded Tailscale/LAN IPs, SQLite references, old Home Assistant/node-red artifacts, and banned IP references in archived Dragon Ball/Ghibli-era files. Nothing should be copied directly without a clean-room review and rewrite.
- Installed `/home/joshuar/Downloads/embral_cursor_rules.md` as project-root `.cursorrules`.
- Completed the requested 5-question audit before gameplay edits: `scenes/player/Player.tscn` existed but lacked in-scene KayKit/InteractRadius/animation nodes; player movement was world/player-axis fallback, not camera-facing; HUD labels existed; HubWorld portals were interaction-gated instead of body-enter transitions.
- Phase 1 player pass: `Player.tscn` now has visible KayKit Knight model, capsule collider, SpringArm/Camera3D, InteractRadius, InteractPrompt, and controller support for camera-facing movement, walk/run speeds, gravity, interaction prompt, and Idle/Walking/Running animation playback.
- Added canonical input actions in `project.godot`: `move_left`, `move_right`, `move_forward`, `move_back`, and `pause`.
- Rebuilt `scenes/overworld/TestScene.tscn` as a flat-plane runtime test with Player, WorldEnvironment, light, ground, and an interactable cube.
- Runtime-window verified Phase 1 visually using `kstart5` + `spectacle`: `/tmp/embral_phase1_prompt.png` shows the KayKit player, camera view, ground plane, and visible `[X] Pick Up` prompt.
- Engine-level motion check confirmed movement changes player position by about 1.6m and that the KayKit `AnimationPlayer` has Idle/Walking/Running animations. This is not a substitute for a physical keyboard/controller playtest, but it caught and fixed the missing prompt detection.
- Fixed `InteractRadius` prompt reliability by keeping Area3D signals and adding a distance scan of nodes in group `interactable`, so static interactables already inside range still show the prompt.
- Patched `addons/godot_ai/utils/log_buffer.gd` to collapse consecutive duplicate MCP log lines into a single repeat-count line, reducing the visible readiness log flood.
- Phase 2 partial: HubWorld `PlayerSpawn` now exists at `(0,0,5)`, Player starts there, portal marker body entry now calls `TransitionManager.change_scene()` for unlocked portals, and dungeon/house runtime trigger areas show HUD messages.
- Cleaned HubWorld visible clutter by hiding placeholder panels/overlays on start: DialoguePanel, QuestUI, QuestCompleteDialog, MobileControls, ShopUI, DailyProgressTracker, QuestTimer, AchievementPopup, ParentDashboard, and the huge FirstStepsGuide label.
- Runtime-window verified HubWorld visual cleanup using `kstart5` + `spectacle`: `/tmp/embral_hubworld_phase2_clean.png` shows the player, coins, portal object, HUD objective, and no placeholder dialogue/timer/mobile overlays.

---

## NEXT TASK
Continue Phase 2 from a physical Play session: walk the player into each HubWorld portal and confirm the body-enter transition reaches the matching realm; collect coins and confirm the HUD gold counter increments; walk to dungeon gate and house door and confirm HUD messages. Then continue Phase 3 realm scene visual polish.

## KNOWN ISSUES
- Working tree was already dirty at session start with many modified and untracked files, especially `addons/godot_ai/`.
- Headless quick-quit checks still print Godot shutdown leak/resource warnings, but boot, HubWorld load, menu-to-world flow, and save/reward persistence checks exit with code 0.
- PS5/generic controller movement should work through Godot joypad mappings once paired by the OS. Godot now detects the connected DualSense as joypad 0; physical movement playtest is still needed in the running game window.
- Wii remote support is not 100% verified. The base game now has standard joypad mappings, but a Wii remote must be paired/mapped by the OS or adapter layer so Godot sees it as a normal joypad.
- The realm scenes are playable MVP spaces with NPC guide interactions and return portals; they are not full quest-complete realm campaigns yet.
- Tutorial MVP route is runtime-verified for one starter quest from each of six realms. It is not a 21-quest-per-realm tutorial; that content does not exist in the repo.
- `player_3` and `player_4` test profiles created during verification were removed; older local profiles were left untouched.
- Current quest data is not fully Sage-backed. A dedicated content pass is needed to rewrite/extend each quest to the `SAGE_PERSONA.md` standard while keeping quests hand-authored and copyright-clean.
- `Godot-MCP-Native` was not installed because `addons/godot_mcp/` already exists. It needs a side-by-side comparison or a deliberate replacement plan before use.
- Questaria quarantine is not clean source material. Reuse only concepts or small code patterns after removing banned dependencies, hardcoded IPs, and legacy copyrighted references.
- Project `godot --headless --path . --check-only` still exits 0 but prints existing quick-shutdown resource leak errors from autoload/editor plugin teardown. Scene loads for Player test and HubWorld work, but the "zero errors" bar is not fully met until that shutdown noise is fixed.
- Phase 1 is visually present and engine-verified, but a human/physical keyboard or PS5 controller playtest still needs to confirm feel, facing, and animation responsiveness.
- Phase 2 is partial. HubWorld is cleaner and portals now transition on body entry in code, but portal traversal, coin collection, dungeon/house trigger messages, and Ignavarr interaction still need physical Play-session confirmation.

## FILES MODIFIED
- 3d_prints/infinity_cube/INSTRUCTIONS.md
- docs/SESSION.md
- docs/AI_CONTEXT.md
- docs/compatibility.md
- docs/HANDOFF_HUBWORLD_INPUT.md
- docs/roadmap.md
- manifest.yaml
- project.godot
- scenes/entities/EmberSigil.tscn
- scenes/overworld/hearthveil/HubWorld.tscn
- scenes/overworld/ember_hollow/ember_hollow.tscn
- scenes/overworld/forge_run/forge_run.tscn
- scenes/overworld/rootstead/rootstead.tscn
- scenes/overworld/the_drift/the_drift.tscn
- scenes/overworld/the_spire/the_spire.tscn
- scenes/overworld/tidemark/tidemark.tscn
- scenes/ui/TestingLevelUI.tscn
- scripts/autoloads/hardware_manager.gd
- scripts/autoloads/save_manager.gd
- scripts/hardware/wii_input.gd
- scripts/models/player_profile.gd
- scripts/ui/AvatarCreator.gd
- scripts/ui/PlayerHUD.gd
- scripts/ui/portal_marker.gd
- scenes/ui/PlayerHUD.tscn
- scripts/world/HubWorldManager.gd
- scripts/world/ember_sigil.gd
- scripts/world/realm_scene.gd
- scripts/world/tutorial_manager.gd
- scripts/player/player_controller.gd
- scenes/player/Player.tscn
- scenes/overworld/TestScene.tscn
- .cursorrules
- addons/godot_ai/utils/log_buffer.gd
- data/quests/hearthveil/hv_ignavarr_tutorial_01.json
- scripts/npc/QuestGiver.gd
- assets/models/kaykit_adventurers/
- /home/joshuar/.agents/skills/typescript-e2e-testing/SKILL.md
- /home/joshuar/Desktop/PlayEmbral.desktop
- /home/joshuar/.local/share/applications/PlayEmbral.desktop
- Phase 2 COMPLETE: 2026-05-14 — HubWorld visually relaunched in Godot 4.6.2 with player, HUD, coins, and portal structures visible; engine audit confirmed portal transition path, coin-to-HUD path, dungeon gate HUD message path, player house locked-message path, and IgnavarrInteract emitting npc_dialogue_started.
- Phase 3 COMPLETE: 2026-05-14 — All six realm scenes launched and screenshot-verified with themed terrain, raised platforms, visible KayKit guides, PlayerHUD, player spawn, and Return to Hearthveil portal; engine audit confirmed each starter NPC emits the expected tutorial npc_id and each return portal targets HubWorld.
