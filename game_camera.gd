extends Camera2D

# Camera tilt settings
@export var tilt_sensitivity: float = 5.0 ## How much the camera moves.
@export var tilt_smoothing: float = 5.0 ## How smooth the movement is.
@export var tilt_deadzone: float = 0.2 ## Minimum tilt before camera moves.

var target_offset: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
    # Enable accelerometer input.
    Input.set_accelerometer(Vector3.ZERO)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    # Get device gravity (accelerometer data).
    var gravity = Input.get_accelerometer()
    
    # Apply deadzone.
    var adjusted_gravity = Vector2.ZERO
    if abs(gravity.x) > tilt_deadzone:
        adjusted_gravity.x = gravity.x
    if abs(gravity.y) > tilt_deadzone:
        adjusted_gravity.y = gravity.y
    
    # Convert gravity to camera offset.
    # X and Y are swapped/inverted depending on device orientation.
    # Adjust these multipliers based on your game's orientation.
    target_offset.x = adjusted_gravity.x * tilt_sensitivity
    target_offset.y = -adjusted_gravity.y * tilt_sensitivity
    
    # Smoothly interpolate to target offset.
    offset = offset.lerp(target_offset, tilt_smoothing * delta)
