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
	if title_music.playing:
		return
	else:
		title_music.volume_db = SILENT_DB
		title_music.play()
		var tween := create_tween()
		tween.tween_property(title_music, "volume_db", NORMAL_DB, fade_duration)


func _play_game_play_music() -> void:
	if game_play_music.playing:
		return
	else:
		game_play_music.play()


## Stop any music currently playing.
## Title music will stop after a brief fade out.
## Game play music will stop abruptly.
func _stop() -> void:
	if title_music.playing:
		var tween := create_tween()
		tween.tween_property(title_music, "volume_db", SILENT_DB, fade_duration)
		await tween.finished
		title_music.stop()
		title_music.volume_db = NORMAL_DB
	if game_play_music.playing:
		game_play_music.stop()


func _on_game_state_changed(state: Constants.GameState) -> void:
	match state:
		Constants.GameState.TITLE:
			_play_title_music()
		Constants.GameState.PLAYING:
			await _stop()
			_play_game_play_music()
		Constants.GameState.SUCCESS:
			pass
		Constants.GameState.TIMEUP:
			_stop()
		Constants.GameState.FINISHED:
			_play_title_music()