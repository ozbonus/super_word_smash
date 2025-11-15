extends Node

signal game_state(state: Constants.GameState)
var current_state: Constants.GameState

func _emit_state(state: Constants.GameState) -> void:
	current_state = state
	game_state.emit(state)

func emit_title_state() -> void:
	_emit_state(Constants.GameState.TITLE)

func emit_counting_state() -> void:
	_emit_state(Constants.GameState.COUNTING)

func emit_playing_state() -> void:
	_emit_state(Constants.GameState.PLAYING)

func emit_success_state() -> void:
	_emit_state(Constants.GameState.SUCCESS)

func emit_timeup_state() -> void:
	_emit_state(Constants.GameState.TIMEUP)

func emit_perfect_state() -> void:
	_emit_state(Constants.GameState.PERFECT)

func emit_finished_state() -> void:
	_emit_state(Constants.GameState.FINISHED)
