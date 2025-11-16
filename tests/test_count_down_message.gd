extends Node

@onready var message: CanvasLayer = $CountDownMessage


func _ready():
	message.play()