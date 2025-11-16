extends Node

@onready var message: CanvasLayer = $CountDownMessage

# Called when the node enters the scene tree for the first time.
func _ready():
	message.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
