#!/bin/bash
REALM_COLORS='{"hearthveil":"Color(1.0, 0.6, 0.1)", "ember_hollow":"Color(1.0, 0.3, 0.1)", "tidemark":"Color(0.1, 0.5, 1.0)", "forge_run":"Color(0.7, 0.8, 1.0)", "rootstead":"Color(0.2, 0.7, 0.2)", "the_spire":"Color(1.0, 0.9, 0.1)", "the_drift":"Color(0.8, 0.4, 1.0)"}'

for npc in $(cat npc_list.txt); do
  # Get data from yaml
  realm=$(grep "realm:" data/npcs/$npc.yaml | awk '{print $2}')
  display_name=$(grep "display_name:" data/npcs/$npc.yaml | cut -d: -f2- | sed 's/^ //')
  color=$(echo $REALM_COLORS | jq -r ".$realm")
  
  # Generate tscn
  cat << TSCN > scenes/npcs/$npc.tscn
[gd_scene load_steps=6 format=3 uid="uid://$npc"]

[ext_resource type="Script" path="res://scripts/npcs/base_teacher_npc.gd" id="1_script"]

[sub_resource type="CapsuleMesh" id="CapsuleMesh_mesh"]
material = SubResource("StandardMaterial3D_mat")

[sub_resource type="StandardMaterial3D" id="StandardMaterial3D_mat"]
albedo_color = $color

[sub_resource type="SphereShape3D" id="SphereShape3D_prox"]
radius = 2.5

[node name="NPC" type="CharacterBody3D"]
script = ExtResource("1_script")
npc_id = "$npc"
display_name = $display_name
realm = "$realm"

[node name="MeshInstance3D" type="MeshInstance3D" parent="."]
mesh = SubResource("CapsuleMesh_mesh")

[node name="CollisionShape3D" type="CollisionShape3D" parent="."]
shape = SubResource("CapsuleShape3D_body")

[node name="ProximityZone" type="Area3D" parent="."]

[node name="CollisionShape3D" type="CollisionShape3D" parent="ProximityZone"]
shape = SubResource("SphereShape3D_prox")

[node name="NameLabel" type="Label3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 2.2, 0)
text = $display_name

[node name="InteractPrompt" type="Label3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 2.7, 0)
visible = false
text = "Press E to talk"
TSCN
done
