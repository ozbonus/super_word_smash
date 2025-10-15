extends Node


@onready var label: Label = $Label

# Called when the node enters the scene tree for the first time.
func _ready():
	TimerService.time_left.connect(_on_timer_service_time_left)

func _on_timer_service_time_left(seconds: float) -> void:
	label.text = "%d" % ceil(seconds)