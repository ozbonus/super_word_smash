extends Node

signal starting_game
signal success_began
signal success_ended

@export var levels: Array[PackedScene]

var current_level_index: int = 0
var current_level_instance: Node

func _ready():
	starting_game.connect(GameStateService._on_starting_game)
	success_began.connect(GameStateService._on_success_began)
	success_ended.connect(GameStateService._on_success_ended)
	$SuccessTimer.wait_time = Constants.TRANSITION_DURATION_SECONDS
	load_level(current_level_index)


func load_level(index: int):
	for child in $Level.get_children():
		child.queue_free()

	await get_tree().process_frame

	current_level_instance = levels[index].instantiate()
	$Level.add_child(current_level_instance)

	if current_level_instance.has_signal("start_game"):
		current_level_instance.start_game.connect(start_game)
	
	if current_level_instance.has_signal("play_again"):
		current_level_instance.play_again.connect(play_again)
	
	if current_level_instance.has_signal("success"):
		current_level_instance.success.connect(handle_success)


func next_level():
	current_level_index += 1
	if current_level_index < levels.size():
		load_level(current_level_index)
	else:
		print_debug("All levels have been completed.")


func start_game(game_length: Constants.GameLength):
	starting_game.emit()
	match game_length:
		Constants.GameLength.SHORT:
			TimerService.start_short_timer()
		Constants.GameLength.MEDIUM:
			TimerService.start_medium_timer()
		Constants.GameLength.LONG:
			TimerService.start_long_timer()
	next_level()


func play_again():
	TimerService.reset()
	current_level_index = 0
	load_level(current_level_index)

func handle_success() -> void:
	success_began.emit()
	Engine.time_scale = 0.05
	$SuccessTimer.start()
	await $SuccessTimer.timeout
	Engine.time_scale = 1.0
	success_ended.emit()
	next_level()