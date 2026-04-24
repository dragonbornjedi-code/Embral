#!/bin/bash
DUNGEONS=("mirror_maze:ember_hollow:Mirror Maze" "word_caverns:tidemark:Word Caverns" "obstacle_forge:forge_run:Obstacle Forge" "daily_tower:rootstead:Daily Tower" "gear_gauntlet:the_spire:Gear Gauntlet" "curiosity_cave:the_drift:Curiosity Cave")

for d in "${DUNGEONS[@]}"; do
  IFS=":" read -r id realm name <<< "$d"
  cat << TSCN > scenes/dungeons/$id.tscn
[gd_scene load_steps=2 format=3 uid="uid://$id"]
[ext_resource type="Script" path="res://scripts/dungeon/dungeon_base.gd" id="1_script"]

[node name="$id" type="Node2D"]
script = ExtResource("1_script")
dungeon_id = "$id"
realm = "$realm"
display_name = "$name"

[node name="Ground" type="TileMapLayer" parent="."]

[node name="EntryPoint" type="Node2D" parent="."]
position = Vector2(100, 400)

[node name="ExitPoint" type="Node2D" parent="."]
position = Vector2(1820, 400)

[node name="EnemySpawns" type="Node2D" parent="."]

[node name="Collectibles" type="Node2D" parent="."]

[node name="DungeonHUD" type="CanvasLayer" parent="."]

[node name="RoomLabel" type="Label" parent="DungeonHUD"]
offset_left = 20
offset_top = 20
offset_right = 200
offset_bottom = 50
text = "$name"

[node name="ReturnHint" type="Label" parent="DungeonHUD"]
offset_left = 20
offset_top = 50
offset_right = 300
offset_bottom = 80
text = "Press Escape to return to overworld"

[node name="Camera2D" type="Camera2D" parent="."]
position = Vector2(100, 400)
zoom = Vector2(0.8, 0.8)
TSCN
done
