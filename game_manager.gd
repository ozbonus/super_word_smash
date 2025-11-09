extends Node

signal showing_title
signal starting_game
signal success_began
signal success_ended
signal showing_score

@export var levels: Array[PackedScene]

@onready var transition_screen: ColorRect = $CanvasLayer/TransitionScreen

var current_level_index: int = 0
var current_level_instance: Node

func _ready():
	showing_title.connect(GameStateService._on_showing_title)
	starting_game.connect(GameStateService._on_starting_game)
	success_began.connect(GameStateService._on_success_began)
	success_ended.connect(GameStateService._on_success_ended)
	showing_score.connect(GameStateService._on_showing_score)
	$SuccessTimer.wait_time = Constants.TRANSITION_DURATION_SECONDS
	load_level(current_level_index)
	showing_title.emit()


func load_level(index: int):
	for child in $Level.get_children():
		child.queue_free()

	await get_tree().process_frame

	current_level_instance = levels[index].instantiate()
	$Level.add_child(current_level_instance)

	if current_level_instance.has_signal("start_game"):
		showing_title.emit()
		current_level_instance.start_game.connect(start_game)
	
	if current_level_instance.has_signal("play_again"):
		showing_score.emit()
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
	showing_score.emit()

func handle_success() -> void:
	success_began.emit()
	SoundEffectsService.play_success()
	Engine.time_scale = 0.05
	var transition_shader_material = transition_screen.material as ShaderMaterial
	if transition_shader_material:
		transition_shader_material.set_shader_parameter("invert", true)
		var tween := create_tween()
		tween.set_ignore_time_scale(true)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_interval(1.0)
		tween.tween_method(
			func(value): transition_shader_material.set_shader_parameter("progress", value),
			0.0,
			6.0,
			1.0,
		)
	$SuccessTimer.start()
	await $SuccessTimer.timeout
	Engine.time_scale = 1.0
	success_ended.emit()
	next_level()
	if transition_shader_material:
		var tween := create_tween()
		tween.set_ignore_time_scale(true)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_method(
			func(value): transition_shader_material.set_shader_parameter("progress", value),
			6.0,
			0.0,
			Constants.TRANSITION_DURATION_SECONDS * 0.3,
		)