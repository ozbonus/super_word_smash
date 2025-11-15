extends Node

@onready var play_title_music_button: Button = %PlayTitleMusicButton
@onready var stop_title_music_button: Button = %StopTitleMusicButton
@onready var play_game_play_music_button: Button = %PlayGamePlayMusicButton
@onready var stop_game_play_music_button: Button = %StopGamePlayMusicButton
@onready var stop_button: Button = %StopButton
@onready var game_state_title_button: Button = %GameStateTitleButton
@onready var game_state_counting_button: Button = %GameStateCountingButton
@onready var game_state_playing_button: Button = %GameStatePlayingButton
@onready var game_state_success_button: Button = %GameStateSuccessButton
@onready var game_state_timeup_button: Button = %GameStateTimeupButton
@onready var game_state_perfect_button: Button = %GameStatePerfectButton
@onready var game_state_finished_button: Button = %GameStateFinishedButton


func _ready():
	play_title_music_button.pressed.connect(_on_play_title_music_button_pressed)
	stop_title_music_button.pressed.connect(_on_stop_title_music_button_pressed)
	play_game_play_music_button.pressed.connect(_on_play_game_play_music_button_pressed)
	stop_game_play_music_button.pressed.connect(_on_stop_game_play_music_button_pressed)
	stop_button.pressed.connect(_on_stop_button_pressed)
	game_state_title_button.pressed.connect(_on_game_state_title_button_pressed)
	game_state_counting_button.pressed.connect(_on_game_state_counting_button_pressed)
	game_state_playing_button.pressed.connect(_on_game_state_playing_button_pressed)
	game_state_success_button.pressed.connect(_on_game_state_success_button_pressed)
	game_state_timeup_button.pressed.connect(_on_game_state_timeup_button_pressed)
	game_state_perfect_button.pressed.connect(_on_game_state_perfect_button_pressed)
	game_state_finished_button.pressed.connect(_on_game_state_finished_button_pressed)



func _on_play_title_music_button_pressed():
	MusicService._play_title_music()


func _on_stop_title_music_button_pressed():
	MusicService._stop_title_music()


func _on_play_game_play_music_button_pressed():
	MusicService._play_game_play_music()


func _on_stop_game_play_music_button_pressed():
	MusicService._stop_game_play_music()


func _on_stop_button_pressed():
	MusicService._stop()


func _on_game_state_title_button_pressed():
	GameStateService.game_state.emit(Constants.GameState.TITLE)


func _on_game_state_counting_button_pressed():
	GameStateService.game_state.emit(Constants.GameState.COUNTING)


func _on_game_state_playing_button_pressed():
	GameStateService.game_state.emit(Constants.GameState.PLAYING)


func _on_game_state_success_button_pressed():
	GameStateService.game_state.emit(Constants.GameState.SUCCESS)


func _on_game_state_timeup_button_pressed():
	GameStateService.game_state.emit(Constants.GameState.TIMEUP)


func _on_game_state_perfect_button_pressed():
	GameStateService.game_state.emit(Constants.GameState.PERFECT)


func _on_game_state_finished_button_pressed():
	GameStateService.game_state.emit(Constants.GameState.FINISHED)
