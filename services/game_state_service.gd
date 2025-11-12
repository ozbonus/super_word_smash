extends Node

signal game_state(state: Constants.GameState)
var current_state: Constants.GameState

func _state_change(state: Constants.GameState) -> void:
	current_state = state
	game_state.emit(state)

func _on_showing_title() -> void:
	_state_change(Constants.GameState.TITLE)

func _on_starting_game() -> void:
	_state_change(Constants.GameState.PLAYING)

func _on_success_began() -> void:
	_state_change(Constants.GameState.SUCCESS)

func _on_success_ended() -> void:
	_state_change(Constants.GameState.PLAYING)

func _on_showing_score() -> void:
	_state_change(Constants.GameState.FINISHED)

func _on_time_up() -> void:
	_state_change(Constants.GameState.TIMEUP)

func _on_game_complete() -> void:
	_state_change(Constants.GameState.TIMEUP)