extends RigidBody2D

@export var tilt_sensitivity: float = 100.0
@export var dead_zone: float = 1.0

var calibration: Vector3

func _ready():
	# This might slightly increase responsiveness when touch and motion input
	# are happening simultaneously.
	Input.set_use_accumulated_input(false)
	
	# Assuming that the device is lying flat when the game starts, this will
	# provide an offset that can be used for calibration later.
	await get_tree().process_frame  # Wait one frame for sensors to initialize
	calibration = Input.get_accelerometer()

func _physics_process(_delta):
	var acceleration := Input.get_accelerometer()
	var tilt := acceleration - calibration
	var tilt_2d = Vector2(tilt.x, -tilt.y)
	
	if tilt_2d.length() > dead_zone:
		var adjusted_tilt := tilt_2d.normalized() * (tilt_2d.length() - dead_zone)
		var force := adjusted_tilt * tilt_sensitivity
		apply_central_force(force)
