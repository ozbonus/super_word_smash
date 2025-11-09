extends Node2D

func _on_hit_pressed():
	SoundEffectsService.play_hit()

func _on_success_pressed():
	SoundEffectsService.play_success()

func _on_decoy_pressed():
	SoundEffectsService.play_decoy()
