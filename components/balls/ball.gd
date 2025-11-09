class_name Ball
extends RigidBody2D

const IMPACT_THRESHOLD_MAGNITUDE := 20.0
var previous_velocity_magnitude := 0.0

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

	# Check for high speed impacts with physics objects and play a sound if so.
	if previous_velocity_magnitude > IMPACT_THRESHOLD_MAGNITUDE and linear_velocity.length() < IMPACT_THRESHOLD_MAGNITUDE:
		print_debug(get_contact_count())
		SoundEffectsService.play_hit()
	
	previous_velocity_magnitude = linear_velocity.length()