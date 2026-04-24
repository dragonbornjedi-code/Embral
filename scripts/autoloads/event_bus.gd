extends Node
## EventBus — Cross-system signal bus
## ALL inter-system communication goes through here.
## No script calls another script's methods directly for cross-system events.
## Usage: EventBus.quest_started.emit(quest_id)

# ═══════════════════════════════════════════
# QUEST SIGNALS
# ═══════════════════════════════════════════
signal quest_started(quest_id: String)
signal quest_step_completed(quest_id: String, step_index: int)
signal quest_completed(quest_id: String)
signal quest_failed(quest_id: String)
signal xp_gained(amount: int, source: String)
signal gold_gained(amount: int, source: String)
signal level_up(new_level: int)

# ═══════════════════════════════════════════
# PLAYER SIGNALS
# ═══════════════════════════════════════════
signal player_entered_realm(realm_id: String)
signal player_exited_realm(realm_id: String)
signal realm_unlocked(realm_id: String)
signal player_entered_dungeon(dungeon_id: String)
signal player_exited_dungeon(dungeon_id: String)
signal dungeon_entered(dungeon_id: String)
signal dungeon_completed(dungeon_id: String)
signal battle_started(player_wisp: String, enemy_wisp: String)
signal battle_ended(victory: bool, xp_gained: int)
signal party_changed()
signal scene_changed(path: String, data: Dictionary)

# ═══════════════════════════════════════════
# NPC SIGNALS
# ═══════════════════════════════════════════
signal npc_discovered(npc_id: String)
signal npc_dialogue_started(npc_id: String)
signal npc_dialogue_ended(npc_id: String)
signal npc_mastery_level_up(npc_id: String, new_level: int)

# ═══════════════════════════════════════════
# CREATURE SIGNALS
# ═══════════════════════════════════════════
signal wisp_captured(wisp_id: String)
signal wisp_battle_started(encounter_id: String)
signal wisp_battle_ended(result: String)
signal pet_happiness_changed(pet_id: String, new_value: float)

# ═══════════════════════════════════════════
# HARDWARE SIGNALS
# ═══════════════════════════════════════════
signal hardware_ready(tier: int)
signal ha_online()
signal ha_offline()
signal ps5_connected()
signal wii_connected()

# ═══════════════════════════════════════════
# UI SIGNALS
# ═══════════════════════════════════════════
signal show_notification(message: String, type: String)
signal emotional_checkin_requested()
signal emotional_checkin_completed(mood: String, value: int)
signal parent_dashboard_opened()

# ═══════════════════════════════════════════
# AUDIO SIGNALS
# ═══════════════════════════════════════════
signal sfx_requested(sfx_name: String, position: Variant)
signal music_change_requested(track_id: String)
signal celebration_triggered(intensity: String)
