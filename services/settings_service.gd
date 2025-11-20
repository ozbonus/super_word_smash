## Ephemeral settings that persist between new games, but not full reloads.

extends Node

const LENGTH_MIN = 10.0
const LENGTH_MAX = 300.0
const LENGTH_STEP = 10.0

@export_group("Default settings")
@export var mute_audio := false
@export_range(LENGTH_MIN, LENGTH_MAX, LENGTH_STEP, "suffix:seconds") var game_length := 300.0
