class_name Ball
extends RigidBody2D

func _ready():
	# This might slightly increase responsiveness when touch and motion input
	# are happening simultaneously.
	Input.set_use_accumulated_input(false)

func _physics_process(_delta):
	var gravity := Input.get_gravity()
	var tilt_2d = Vector2(gravity.x, -gravity.y)
	
	if tilt_2d.length() > Constants.DEAD_ZONE:
		var adjusted_tilt := tilt_2d.normalized() * (tilt_2d.length() - Constants.DEAD_ZONE)
		var force := adjusted_tilt * Constants.TILT_SENSITIVITY
		apply_central_force(force)
