class_name GameOverMessage
extends Control

const TIME_UP_MESSAGE = "TIME'S UP!"
const PERFECT_MESSAGE = "PERFECT!"

@onready var label: RichTextLabel = $RichTextLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func show_time_up() -> void:
	label.text = TIME_UP_MESSAGE
	_appear()

func show_perfect() -> void:
	label.text = PERFECT_MESSAGE
	_appear()

func _appear() -> void:
	visible = true
	animation_player.play("appear")