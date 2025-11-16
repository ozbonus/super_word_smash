class_name TitleScreen
extends Node2D

signal start_new_game(length: float)

@onready var less_time_button: Button = %LessTimeButton
@onready var more_time_button: Button = %MoreTimeButton
@onready var game_time_seconds: RichTextLabel = %GameTimeSeconds
@onready var mute_toggle: CheckButton = %MuteToggle

func _ready():
	game_time_seconds.text = "%d" % SettingsService.game_length
	mute_toggle.button_pressed = SettingsService.mute_audio


func _on_mute_toggle_toggled(toggled_on: bool):
	SettingsService.mute_audio = toggled_on
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), toggled_on)


func _on_more_time_button_pressed():
	if SettingsService.game_length < SettingsService.LENGTH_MAX:
		SoundEffectsService.play_click()
		SettingsService.game_length += SettingsService.LENGTH_STEP
		game_time_seconds.text = "%d" % SettingsService.game_length


func _on_less_time_button_pressed():
	if SettingsService.game_length > SettingsService.LENGTH_MIN:
		SoundEffectsService.play_click()
		SettingsService.game_length -= SettingsService.LENGTH_STEP
		game_time_seconds.text = "%d" % SettingsService.game_length


func _on_start_button_pressed():
	SoundEffectsService.play_success()
	start_new_game.emit(SettingsService.game_length)
