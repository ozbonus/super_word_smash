extends Node

signal time_up
signal hurry_up
signal time_left(seconds: float, proportion: float)

## The hurry up signal is emitted when this many seconds remain in the game.
## Setting to 0.0 seconds will safely deactivate the hurry up logic.
@export_range(0.0, 60.0, 1.0, "suffix:seconds") var hurry_up_threshold: float
## How often the `time_left` signal is emitted, in a portion of a second.
@export_range(0.1, 1.0, 0.01, "suffix:seconds") var update_interval: float
## Extra time if timeout occurs during a level transition.
@export_range(1.0, 20.0, 0.1, "suffix:seconds") var success_state_buffer: float

@onready var game_timer: Timer = $GameTimer
@onready var hurry_up_timer: Timer = $HurryUpTimer
@onready var update_timer: Timer = $UpdateTimer

var start_time: int = 0
var finish_time: int = 0


func _ready() -> void:
	update_timer.timeout.connect(_on_update_timer_timeout)
	game_timer.timeout.connect(_on_game_timer_timeout)
	hurry_up_timer.timeout.connect(_on_hurry_up_timer_timeout)
	GameStateService.game_state.connect(_on_game_state)


func start(seconds: float) -> void:
	start_time = Time.get_ticks_msec()
	game_timer.start(seconds)
	update_timer.start(update_interval)
	_on_update_timer_timeout()
	if hurry_up_threshold > 0.0 and hurry_up_threshold < seconds:
		var hurry_up_time = seconds - hurry_up_threshold
		hurry_up_timer.start(hurry_up_time)
	elif hurry_up_threshold > seconds:
		push_warning("Hurry up threshold is larger than game timer duration!\n
			Hurry up threshold: %.1fs\n
			Game duration: %.1fs" % [hurry_up_threshold, seconds])


## Return a string that gives the minutes and seconds that have elapsed since
## the [start_time] variable was last set in the [start] function, i.e., since
## the current game began.
func get_elapsed_time_string() -> String:
	var elapsed_msec = finish_time - start_time
	@warning_ignore_start("integer_division")
	var elapsed_seconds = elapsed_msec / 1000
	var minutes = elapsed_seconds / 60
	var seconds = elapsed_seconds % 60
	@warning_ignore_restore("integer_division")
	return "%d:%02d" % [minutes, seconds]


func _finish_counting() -> void:
	finish_time = Time.get_ticks_msec()


## Stop all timers.
func reset() -> void:
	update_timer.stop()
	game_timer.stop()
	hurry_up_timer.stop()


func _on_game_timer_timeout() -> void:
	# When the game is in the success state it's likely also in the process of
	# transitioning between levels. Entering into the time up state at this point
	# would look awkward, so this if-statement restarts the game timer with just
	# enough time to barely interact with the next level.
	if GameStateService.current_state == Constants.GameState.SUCCESS:
		game_timer.start(success_state_buffer)
	else:
		update_timer.stop()
		time_up.emit()


func _on_hurry_up_timer_timeout() -> void:
	hurry_up.emit()


func _on_update_timer_timeout() -> void:
	var seconds: float = game_timer.time_left
	var proportion: float = game_timer.time_left / max(game_timer.wait_time, 0.01)
	time_left.emit(seconds, proportion)


func _on_game_state(state: Constants.GameState) -> void:
	match state:
		Constants.GameState.PERFECT, Constants.GameState.TIMEUP:
			_finish_counting()
		Constants.GameState.TITLE:
			reset()
		_:
			pass