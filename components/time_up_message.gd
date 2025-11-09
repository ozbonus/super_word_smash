class_name TimeUpMessage
extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func appear() -> void:
	visible = true
	animation_player.play("appear")