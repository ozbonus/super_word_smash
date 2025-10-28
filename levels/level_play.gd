extends Node2D

signal success

func _on_goal_entered():
	success.emit()