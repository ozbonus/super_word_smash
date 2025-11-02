extends Node

signal game_state(state: Constants.GameState)

func _on_starting_game() -> void:
	game_state.emit(Constants.GameState.PLAYING)

func _on_success_began() -> void:
	game_state.emit(Constants.GameState.SUCCESS)

func _on_success_ended() -> void:
	game_state.emit(Constants.GameState.PLAYING)