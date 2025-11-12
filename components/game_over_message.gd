class_name TimeUpMessage
extends Control

const TIMES_UP_MESSAGE = "TIME'S UP!"
const PERFECT_MESSAGE = "PERFECT!"

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func appear() -> void:
	visible = true
	animation_player.play("appear")