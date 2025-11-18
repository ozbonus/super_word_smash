class_name ScoreScreen
extends Node2D

signal play_again

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	animation_player.play("idle")


func _on_button_pressed():
	SoundEffectsService.play_success()
	play_again.emit()
