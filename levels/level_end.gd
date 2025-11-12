class_name ScoreScreen
extends Node2D

signal play_again

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_button_pressed():
	play_again.emit()
