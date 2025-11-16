extends Node

signal showing_title ## Emitted when the title screen is loaded.
signal counting_down ## Emitted when counting down to starting the first level.
signal word_smashing ## Emitted when normal game play has begun.
signal success_began ## Emitted upon hitting a correct target (not last level).
signal success_ended ## Emitted a short while after the success_began signal
signal outta_time_gg ## Emitted when the game play timer completes.
signal perfect_clear ## Emitted when successfully finishing the last level.
signal showing_score ## Emitted when showing the score screen.

# These just so happen to be the progress values that allow the shader-based
# transition to complete fully.
const TRANSITION_PROGRESS_MIN := 0.0
const TRANSITION_PROGRESS_MAX := 6.0

@export_group("Levels")
@export var title_screen: PackedScene
@export var levels: Array[PackedScene]
@export var summary_screen: PackedScene

@export_group("Timers")
@export_range(0.1, 5.0, 0.1, "suffix:seconds") var transition_out_delay: float = 1.0
@export_range(0.1, 5.0, 0.1, "suffix:seconds") var transition_duration: float = 0.5
@export_range(0.1, 5.0, 0.1, "suffix:seconds") var dramatic_pause_duration: float = 1.0

@onready var level: Node2D = $Level
@onready var transition_screen: ColorRect = $CanvasLayer/TransitionScreen
@onready var count_down_message: CanvasLayer = $CountDownMessage
@onready var game_over_message: GameOverMessage = $CanvasLayer/GameOverMessage

var current_level_index: int = 0
var current_level_instance: Node2D


func _ready():
	showing_title.connect(GameStateService.emit_title_state)
	counting_down.connect(GameStateService.emit_counting_state)
	word_smashing.connect(GameStateService.emit_playing_state)
	success_began.connect(GameStateService.emit_success_state)
	success_ended.connect(GameStateService.emit_playing_state)
	outta_time_gg.connect(GameStateService.emit_timeup_state)
	perfect_clear.connect(GameStateService.emit_perfect_state)
	showing_score.connect(GameStateService.emit_finished_state)
	TimerService.time_up.connect(_on_timeup)
	_load_title_screen()


## Clear the currently loaded title, gameplay level, or score screen.
func _clear_current_level() -> void:
	for child in level.get_children():
		child.queue_free()
	await get_tree().process_frame


func _load_title_screen() -> void:
	await _clear_current_level()
	current_level_instance = title_screen.instantiate()
	level.add_child(current_level_instance)
	var title_screen_instance := current_level_instance as TitleScreen
	title_screen_instance.start_new_game.connect(_start_new_game)
	showing_title.emit()


func _start_new_game(game_length: float) -> void:
	await _transition_out()
	await _load_level(0)
	counting_down.emit()
	await _transition_in()
	await count_down_message.play()
	TimerService.start(game_length)
	word_smashing.emit()


func _load_score_screen() -> void:
	await _clear_current_level()
	current_level_instance = summary_screen.instantiate()
	level.add_child(current_level_instance)
	var instance := current_level_instance as ScoreScreen
	instance.play_again.connect(play_again)
	showing_score.emit()


func _load_level(index: int):
	await _clear_current_level()
	current_level_instance = levels[index].instantiate()
	level.add_child(current_level_instance)
	var game_level_instance := current_level_instance as GameLevel
	game_level_instance.success.connect(handle_success)


func next_level():
	current_level_index += 1
	if current_level_index < levels.size():
		_load_level(current_level_index)
	else:
		_perfect_game()


func play_again():
	TimerService.reset()
	current_level_index = 0
	await _transition_out()
	_load_title_screen()
	await _transition_in()


func _on_timeup():
	game_over_message.show_time_up()
	outta_time_gg.emit()
	await _dramatic_pause()
	await _transition_out()
	game_over_message.visible = false
	_load_score_screen()
	await _transition_in()


func handle_success() -> void:
	if current_level_index == levels.size() - 1:
		_perfect_game()
	else:
		success_began.emit()
		SoundEffectsService.play_success()
		Engine.time_scale = 0.05
		await _transition_out()
		next_level()
		success_ended.emit()
		await _transition_in()
		Engine.time_scale = 1.0


func _perfect_game() -> void:
	perfect_clear.emit()
	SoundEffectsService.play_success()
	Engine.time_scale = 0.05
	await _dramatic_pause()
	game_over_message.show_perfect()
	await _transition_out()
	Engine.time_scale = 1.0
	game_over_message.visible = false
	_load_score_screen()
	await _transition_in()


func _dramatic_pause() -> void:
	await get_tree().create_timer(dramatic_pause_duration, true, false, true).timeout


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
			TRANSITION_PROGRESS_MIN,
			TRANSITION_PROGRESS_MAX,
			transition_duration,
		)
		await tween.finished


func _transition_in() -> void:
	var transition_shader_material = transition_screen.material as ShaderMaterial
	if transition_shader_material:
		var tween := create_tween()
		tween.set_ignore_time_scale(true)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_method(
			func(value): transition_shader_material.set_shader_parameter("progress", value),
			TRANSITION_PROGRESS_MAX,
			TRANSITION_PROGRESS_MIN,
			transition_duration,
		)
		await tween.finished