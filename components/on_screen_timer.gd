class_name OnScreenTimer
extends Node


## This is the number that will appear on the on screen time at the beginning of
## the game and then count down to zero. 
@export_range(60, 200, 1, "suffix:unit", "slider") var label_start: int = 60

@onready var label: RichTextLabel = %Label


# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = "%s" % label_start
	TimerService.time_left.connect(_on_timer_service_time_left)


func _on_timer_service_time_left(_seconds: float, proportion: float) -> void:
	var text: int = roundi(proportion * label_start)
	label.text = "%s" % text