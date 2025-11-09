extends Node

@onready var hit: AudioStreamPlayer = $Hit
@onready var success: AudioStreamPlayer = $Success
@onready var decoy: AudioStreamPlayer = $Decoy

func play_hit():
	hit.play()

func play_success():
	success.play()

func play_decoy():
	decoy.play()