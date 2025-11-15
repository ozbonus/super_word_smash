## Ephemeral settings that persist between new games, but not full reloads.

extends Node

@export_group("Default settings")
@export var mute_audio := true
@export_range(10.0, 300.0, 10.0, "suffix:seconds") var game_length := 60.0
