class_name Ball
extends RigidBody2D


func _ready():
	# This might slightly increase responsiveness when touch and motion input
	# are happening simultaneously.
	Input.set_use_accumulated_input(false)
	GameStateService.game_state.connect(_on_game_state)


func _physics_process(_delta):
	if !freeze:
		var gravity := Input.get_gravity()
		var tilt_2d = Vector2(gravity.x, -gravity.y)
		
		if tilt_2d.length() > Constants.DEAD_ZONE:
			var adjusted_tilt := tilt_2d.normalized() * (tilt_2d.length() - Constants.DEAD_ZONE)
			var force := adjusted_tilt * Constants.TILT_SENSITIVITY
			apply_central_force(force)


func _on_game_state(state: Constants.GameState):
	match state:
		Constants.GameState.TITLE:
			freeze = true
		Constants.GameState.COUNTING:
			freeze = true
		Constants.GameState.PLAYING:
			freeze = false
		Constants.GameState.SUCCESS:
			freeze = false
		Constants.GameState.TIMEUP:
			linear_velocity = Vector2.ZERO
			angular_velocity = 0.0
			freeze = true
		Constants.GameState.PERFECT:
			pass
		Constants.GameState.FINISHED:
			pass