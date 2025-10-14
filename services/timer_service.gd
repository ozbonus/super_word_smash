extends Node


signal time_up
signal hurry_up
signal time_left(seconds: float)


## The duration of a short length game, in seconds.
@export_range(0.0, 180.0, 1.0, "suffix:seconds") var short_time: float
## The duration of a medium length game, in seconds.
@export_range(0.0, 180.0, 1.0, "suffix:seconds") var medium_time: float
## The duration of a long length game, in seconds.
@export_range(0.0, 180.0, 1.0, "suffix:seconds") var long_time: float
## The hurry up signal is emitted when this many seconds remain in the game.
## Setting to 0.0 seconds will safely deactivate the hurry up logic.
@export_range(0.0, 60.0, 1.0, "suffix:seconds") var hurry_up_threshold: float
## How often the `time_left` signal is emitted, in a portion of a second.
@export_range(0.1, 1.0, 0.01, "suffix:seconds") var update_interval: float


@onready var game_timer: Timer = $GameTimer
@onready var hurry_up_timer: Timer = $HurryUpTimer
@onready var update_timer: Timer = $UpdateTimer


func _ready() -> void:
	update_timer.timeout.connect(_on_update_timer_timeout)
	game_timer.timeout.connect(_on_game_timer_timeout)
	hurry_up_timer.timeout.connect(_on_hurry_up_timer_timeout)


func _start_timers(seconds: float) -> void:
	game_timer.start(seconds)
	update_timer.start(update_interval)
	if hurry_up_threshold > 0.0 and hurry_up_threshold < seconds:
		var hurry_up_time = seconds - hurry_up_threshold
		hurry_up_timer.start(hurry_up_time)
	elif hurry_up_threshold > seconds:
		push_warning("Hurry up threshold is larger than game timer duration!")


## Stop all timers.
func reset() -> void:
	update_timer.stop()
	game_timer.stop()
	hurry_up_timer.stop()


## Start a game timer with a short duration.
func start_short_timer() -> void:
	_start_timers(short_time)


## Start a game timer with a medium duration.
func start_medium_timer() -> void:
	_start_timers(medium_time)


## Start a game timer with a long duration.
func start_long_timer() -> void:
	_start_timers(long_time)


func _on_game_timer_timeout() -> void:
	time_up.emit()


func _on_hurry_up_timer_timeout() -> void:
	hurry_up.emit()


func _on_update_timer_timeout() -> void:
	time_left.emit(game_timer.time_left)