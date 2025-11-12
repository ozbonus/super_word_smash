extends Node

signal showing_title
signal starting_game
signal success_began
signal success_ended
signal showing_score

@export_group("Levels")
@export var title_screen: PackedScene
@export var levels: Array[PackedScene]
@export var summary_screen: PackedScene

@export_group("Timers")
@export_range(0.1, 5.0, 0.1, "suffix:seconds") var transition_out_delay: float = 1.0
@export_range(0.1, 5.0, 0.1, "suffix:seconds") var transition_duration: float = 0.5

@onready var level: Node2D = $Level
@onready var transition_screen: ColorRect = $CanvasLayer/TransitionScreen
@onready var game_over_message: GameOverMessage = $GameOverMessage
@onready var success_timer: Timer = $SuccessTimer
@onready var game_over_timer: Timer = $GameOverTimer

var current_level_index: int = 0
var current_level_instance: Node

func _ready():
	showing_title.connect(GameStateService._on_showing_title)
	starting_game.connect(GameStateService._on_starting_game)
	success_began.connect(GameStateService._on_success_began)
	success_ended.connect(GameStateService._on_success_ended)
	showing_score.connect(GameStateService._on_showing_score)
	TimerService.time_up.connect(_on_timeup)
	success_timer.wait_time = Constants.TRANSITION_DURATION_SECONDS
	_load_title_screen()

## Clear the currently loaded title, gameplay level, or summary screen.
func _clear_current_level() -> void:
	for child in level.get_children():
		child.queue_free()
	await get_tree().process_frame


func _load_title_screen() -> void:
	_clear_current_level()
	current_level_instance = title_screen.instantiate()
	level.add_child(current_level_instance)
	var title_screen_instance := current_level_instance as TitleScreen
	title_screen_instance.start_game.connect(start_game)
	showing_title.emit()


func _load_score_screen() -> void:
	_clear_current_level()
	current_level_instance = summary_screen.instantiate()
	level.add_child(current_level_instance)
	var instance := current_level_instance as ScoreScreen
	instance.play_again.connect(play_again)
	showing_score.emit()


func load_level(index: int):
	_clear_current_level()
	current_level_instance = levels[index].instantiate()
	level.add_child(current_level_instance)
	var game_level_instance := current_level_instance as GameLevel
	game_level_instance.success.connect(handle_success)


func next_level():
	current_level_index += 1
	if current_level_index < levels.size():
		load_level(current_level_index)
	else:
		_load_score_screen()


func start_game(game_length: Constants.GameLength):
	starting_game.emit()
	match game_length:
		Constants.GameLength.SHORT:
			TimerService.start_short_timer()
		Constants.GameLength.MEDIUM:
			TimerService.start_medium_timer()
		Constants.GameLength.LONG:
			TimerService.start_long_timer()
	load_level(0)


func play_again():
	TimerService.reset()
	current_level_index = 0
	_load_title_screen()


func _on_timeup():
	game_over_message.show_time_up()
	game_over_timer.start()
	_transition_out()
	await game_over_timer.timeout
	game_over_message.visible = false
	_load_score_screen()
	_transition_in()


func handle_success() -> void:
	success_began.emit()
	SoundEffectsService.play_success()
	Engine.time_scale = 0.05
	_transition_out()
	success_timer.start()
	await success_timer.timeout
	Engine.time_scale = 1.0
	success_ended.emit()
	next_level()
	_transition_in()

func _transition_out() -> void:
	var transition_shader_material = transition_screen.material as ShaderMaterial
	if transition_shader_material:
		transition_shader_material.set_shader_parameter("invert", true)
		var tween := create_tween()
		tween.set_ignore_time_scale(true)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_interval(transition_out_delay)
		tween.tween_method(
			func(value): transition_shader_material.set_shader_parameter("progress", value),
			0.0,
			6.0,
			transition_duration,
		)

func _transition_in() -> void:
	var transition_shader_material = transition_screen.material as ShaderMaterial
	if transition_shader_material:
		var tween := create_tween()
		tween.set_ignore_time_scale(true)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_method(
			func(value): transition_shader_material.set_shader_parameter("progress", value),
			6.0,
			0.0,
			transition_duration,
		)