class_name Ball
extends RigidBody2D

@export var tilt_sensitivity: float = 100.0
@export var dead_zone: float = 1.0

func _ready():
	# This might slightly increase responsiveness when touch and motion input
	# are happening simultaneously.
	Input.set_use_accumulated_input(false)

func _physics_process(_delta):
	var gravity := Input.get_gravity()
	var tilt_2d = Vector2(gravity.x, -gravity.y)
	
	if tilt_2d.length() > dead_zone:
		var adjusted_tilt := tilt_2d.normalized() * (tilt_2d.length() - dead_zone)
		var force := adjusted_tilt * tilt_sensitivity
		apply_central_force(force)
