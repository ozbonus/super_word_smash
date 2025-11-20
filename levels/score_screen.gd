class_name ScoreScreen
extends Node2D

signal play_again

@onready var time_label: Label = %TimeLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	var elapsed_time = TimerService.get_elapsed_time_string()
	time_label.text = "Time %s" % elapsed_time
	animation_player.play("idle")


func _on_button_pressed():
	SoundEffectsService.play_success()
	play_again.emit()
