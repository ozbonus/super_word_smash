extends Node2D

## Verify that the emission rate of particles appears constant when the game
## enters a success state. The speed scale of the particles is modified by a
## function that watches for the game state signal from the game state service
## rather than watch the engine time scale directly, thus the two separate calls
## to the engine time scale and the game state signal.

@onready var scale_label: Label = $Label

func _ready():
	show_engine_time_scale()

func _exit_tree():
	Engine.time_scale = 1.0

func show_engine_time_scale() -> void:
	scale_label.text = "Engine time_scale: %.2f" % Engine.time_scale

func _on_check_button_toggled(toggled_on: bool):
	if toggled_on:
		Engine.time_scale = Constants.SUCCESS_TIME_SCALE
		await get_tree().process_frame
		GameStateService.game_state.emit(Constants.GameState.SUCCESS)
	else:
		Engine.time_scale = 1.0
		await get_tree().process_frame
		GameStateService.game_state.emit(Constants.GameState.PLAYING)
	show_engine_time_scale()
