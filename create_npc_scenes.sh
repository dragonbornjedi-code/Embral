#!/bin/bash
REALM_COLORS='{"hearthveil":"Color(1.0, 0.6, 0.1)", "ember_hollow":"Color(1.0, 0.3, 0.1)", "tidemark":"Color(0.1, 0.5, 1.0)", "forge_run":"Color(0.7, 0.8, 1.0)", "rootstead":"Color(0.2, 0.7, 0.2)", "the_spire":"Color(1.0, 0.9, 0.1)", "the_drift":"Color(0.8, 0.4, 1.0)"}'

# Extract NPCs from manifest (simplified)
NPC_IDS=("ignavarr" "drift_build" "drift_draw" "drift_music" "drift_story" "ember_ember" "ember_kind" "ember_mirror" "ember_soothe" "forge_balance" "forge_build" "forge_dance" "forge_throw" "root_chores" "root_food" "root_hygiene" "root_time" "spire_math" "spire_numbers" "spire_plants" "spire_weather" "tide_letter" "tide_sound" "tide_story" "tide_word")

for npc in "${NPC_IDS[@]}"; do
  # Determine realm and display_name (using simplified mapping or yaml read)
  # For this task, we will infer realm from ID prefix if possible
  
  # Set script
  script="res://scripts/npcs/base_teacher_npc.gd"
  if [ "$npc" == "ignavarr" ]; then script="res://scripts/npcs/teachers/ignavarr.gd"; fi

  cat << TSCN > scenes/npcs/$npc.tscn
[gd_scene load_steps=5 format=3 uid="uid://$npc"]
[ext_resource type="Script" path="$script" id="1_script"]

[sub_resource type="CapsuleMesh" id="CapsuleMesh_mesh"]
radius = 0.5
height = 2.0

[sub_resource type="CapsuleShape3D" id="CapsuleShape3D_player"]
radius = 0.5
height = 2.0

[sub_resource type="SphereShape3D" id="SphereShape3D_prox"]
radius = 2.5

[node name="NPC" type="CharacterBody3D"]
script = ExtResource("1_script")
npc_id = "$npc"

[node name="MeshInstance3D" type="MeshInstance3D" parent="."]
mesh = SubResource("CapsuleMesh_mesh")

[node name="CollisionShape3D" type="CollisionShape3D" parent="."]
shape = SubResource("CapsuleShape3D_player")

[node name="ProximityZone" type="Area3D" parent="."]
[node name="CollisionShape3D" type="CollisionShape3D" parent="ProximityZone"]
shape = SubResource("SphereShape3D_prox")

[node name="NameLabel" type="Label3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 2.2, 0)
text = "$npc"

[node name="InteractPrompt" type="Label3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 2.7, 0)
visible = false
text = "Press E to talk"
TSCN
done
