# This is the Ball! It's the main thing you control in the game by tilting your
# device. You can win the game by moving the ball onto words that describe what
# the ball looks like. This code tells the ball how to move and when it's
# allowed to move.
class_name Ball
extends RigidBody2D

## How quickly the ball moves depending on how much the device is tilted.
const TILT_SENSITIVITY = 1000.0
## How much the device must be tilted before any movement happens.
const DEAD_ZONE: float = 1.0


func _ready():
	# This might slightly increase responsiveness when touch and motion input
	# are happening simultaneously.
	Input.set_use_accumulated_input(false)
	# This tells the ball to pay attention to the overall state of the game.
	# "State" means what's currently happening - like "counting down", "playing",
	# or "time's up!"
	GameStateService.game_state.connect(_on_game_state)


# This function handles moving the ball based on how the device (probably a
# tablet) is being tilted. First it takes some information from the device about
# it's being tilted, then it uses the number to push the ball a little bit. That
# sounds like a lot of work, but actually this function has to run 60 times
# every second! That's once every 0.016 seconds,
# which is so fast that the ball looks like it's moving smoothly.
func _physics_process(_delta):
	# Only allow the ball to move by tilting the device if the ball is not frozen.
	# ("freeze" is a special variable that tells the ball whether it can move or not)
	if !freeze:
		# Gravity is a number the device can give to the game. It tells the game
		# which way is down in relation to the device. We can know how much the
		# device is tilting in a direction with this information.
		var gravity := Input.get_gravity()
		# The device thinks in 3D (up/down, left/right, forward/backward), but this
		# game is flat like a piece of paper (2D), so we only need the left/right
		# and up/down parts.
		var tilt_2d = Vector2(gravity.x, -gravity.y)
		
		# Check if the device is tilted more than just a little bit. This is like
		# having a "dead zone" - small tilts don't do anything, which prevents the
		# ball from wiggling when you're trying to hold the device still.
		if tilt_2d.length() > DEAD_ZONE:
			var adjusted_tilt := tilt_2d.normalized() * (tilt_2d.length() - DEAD_ZONE)
			var force := adjusted_tilt * TILT_SENSITIVITY
			apply_central_force(force)


# This function changes what the ball does based on the overall state of the
# game. Sometimes the ball is allowed to move, and sometimes it's not.
func _on_game_state(state: Constants.GameState):
	match state:
		Constants.GameState.COUNTING:
			# Don't allow the ball to move during the 3-2-1-Go! at the beginning of
			# the game.
			freeze = true
		Constants.GameState.PLAYING, Constants.GameState.SUCCESS:
			# Allow the ball to move during normal game play and also during the slow
			# motion period that happens after reaching a goal.
			freeze = false
		Constants.GameState.TIMEUP:
			# Completely stop movement when the game play timer finishes. Otherwise
			# the ball might accidentally reach a goal after the game is over.
			linear_velocity = Vector2.ZERO
			angular_velocity = 0.0
			freeze = true
		# There are other game states (like showing the title screen or score), but
		# there aren't any balls in the game during those times, so this line says
		# we can safely ignore them.
		_:
			pass