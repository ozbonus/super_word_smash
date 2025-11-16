extends Node

@onready var hit: AudioStreamPlayer = $Hit
@onready var success: AudioStreamPlayer = $Success
@onready var decoy: AudioStreamPlayer = $Decoy
@onready var click: AudioStreamPlayer = $Click
@onready var count: AudioStreamPlayer = $Count
@onready var go: AudioStreamPlayer = $Go

func play_hit():
	hit.play()

func play_success():
	success.play()

func play_decoy():
	decoy.play()

func play_click():
	click.play()

func play_count():
	count.play()

func play_go():
	go.play()