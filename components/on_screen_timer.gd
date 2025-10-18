extends Node


## This is the number that will appear on the on screen time at the beginning of
## the game and then count down to zero. 
@export_range(60, 200, 1, "suffix:seconds") var label_start

@onready var label: Label = $Label


# Called when the node enters the scene tree for the first time.
func _ready():
	TimerService.time_left.connect(_on_timer_service_time_left)


func _on_timer_service_time_left(seconds: float) -> void:
	label.text = "%d" % ceil(seconds)