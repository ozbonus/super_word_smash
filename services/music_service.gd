extends Node

const NORMAL_DB = 0.0
const SILENT_DB = -80.0

@export_range(0.0, 5.0, 0.1, "suffix:seconds") var fade_duration: float = 0.5

@onready var title_music: AudioStreamPlayer = $TitleMusic
@onready var game_play_music: AudioStreamPlayer = $GamePlayMusic


func _ready():
	GameStateService.game_state.connect(_on_game_state_changed)


## Play the title music of the game with a brief fade in.
## Do nothing if it's already playing, like when returning to the main menu.
func _play_title_music() -> void:
	if not title_music.playing:
		title_music.volume_db = SILENT_DB
		title_music.play()
		var tween := create_tween()
		tween.tween_property(title_music, "volume_db", NORMAL_DB, fade_duration)


func _play_game_play_music() -> void:
	if not game_play_music.playing:
		game_play_music.play()


## Stop the title music after a brief fade out.
func _stop_title_music() -> void:
	if title_music.playing:
		if fade_duration == 0.0:
			title_music.stop()
		else:
			var tween := create_tween()
			tween.tween_property(title_music, "volume_db", SILENT_DB, fade_duration)
			await tween.finished
			title_music.stop()
			title_music.volume_db = NORMAL_DB


## Stop the game play music abruptly.
func _stop_game_play_music() -> void:
	if game_play_music.playing:
		game_play_music.stop()


## Stop all track immediately.
func _stop() -> void:
	if title_music.playing:
		title_music.stop()
	if game_play_music.playing:
		game_play_music.stop()


func _on_game_state_changed(state: Constants.GameState) -> void:
	match state:
		Constants.GameState.TITLE:
			_stop_game_play_music() ## In case of restart in the middle of the game.
			_play_title_music()
		Constants.GameState.COUNTING:
			_stop_title_music()
		Constants.GameState.PLAYING:
			_play_game_play_music()
		Constants.GameState.SUCCESS:
			pass
		Constants.GameState.TIMEUP:
			_stop_game_play_music()
		Constants.GameState.PERFECT:
			_stop_game_play_music()
		Constants.GameState.FINISHED:
			_play_title_music()