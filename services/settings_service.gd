## Ephemeral settings that persist between new games, but not full reloads.

extends Node

const GAME_LENGTH_STEP = 10.0

@export_group("Default settings")
@export var mute_audio := true
@export_range(10.0, 300.0, GAME_LENGTH_STEP, "suffix:seconds") var game_length := 60.0
