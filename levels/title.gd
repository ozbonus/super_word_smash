## The exact durations of the various game lengths are set in the TimerService.
extends Node2D


signal start_game(length: Constants.GameLength)


func _on_short_game_button_pressed():
	start_game.emit(Constants.GameLength.SHORT)


func _on_medium_game_button_pressed():
	start_game.emit(Constants.GameLength.MEDIUM)


func _on_long_game_button_pressed():
	start_game.emit(Constants.GameLength.LONG)
