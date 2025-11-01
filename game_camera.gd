extends Camera2D


enum CameraState { FIXED, JUICY }


# var camera_state : CameraState = CameraState.FIXED
var camera_state := CameraState.FIXED


# Camera tilt settings
@export var tilt_sensitivity: float = 5.0 ## How much the camera moves.
@export var tilt_smoothing: float = 5.0 ## How smooth the movement is.
@export var tilt_deadzone: float = 0.2 ## Minimum tilt before camera moves.


# Camera zoom/pan settings
@export var success_zoom_level: float = 2.0 ## Zoom level when focusing
@export var zoom_duration: float = 0.5 ## Duration of zoom animation in seconds
@export var zoom_transition: Tween.TransitionType = Tween.TRANS_CUBIC ## Transition curve type
@export var zoom_ease: Tween.EaseType = Tween.EASE_IN_OUT ## Ease type for animation


var target_offset: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
    GameStateService.game_state.connect(_handle_game_state_changes)
    # Enable accelerometer input.
    Input.set_accelerometer(Vector3.ZERO)

func _process(delta):
    if camera_state == CameraState.JUICY:
        juicy_camera(delta)

func juicy_camera(delta) -> void:
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
    # Adjust these multipliers based on the game's orientation.
    target_offset.x = adjusted_gravity.x * tilt_sensitivity
    target_offset.y = -adjusted_gravity.y * tilt_sensitivity
    
    # Smoothly interpolate to target offset.
    offset = offset.lerp(target_offset, tilt_smoothing * delta)


func zoom_to_focus() -> void:
    var focus_node: Node2D = get_tree().current_scene.find_child("Focus", true, false)
    if focus_node:
        var viewport_center = get_viewport_rect().size / 2.0
        var relative_position = focus_node.global_position - viewport_center
        var tween := create_tween()
        tween.set_parallel(true)
        tween.set_ignore_time_scale(true)
        tween.set_trans(zoom_transition)
        tween.set_ease(zoom_ease)
        tween.tween_property(self, "offset", relative_position, zoom_duration)
        tween.tween_property(self, "zoom", Vector2.ONE * success_zoom_level, zoom_duration)
    else:
        print_debug("Focus node not found")


func reset() -> void:
    offset = Vector2.ZERO
    position = Vector2(320.0, 200.0)
    zoom = Vector2.ONE


func _handle_game_state_changes(state) -> void:
    match state:
        Constants.GameState.TITLE, Constants.GameState.FINISHED:
            camera_state = CameraState.FIXED
        Constants.GameState.PLAYING:
            reset()
            camera_state = CameraState.JUICY
        Constants.GameState.SUCCESS:
            zoom_to_focus()
        Constants.GameState.FINISHED:
            reset()
            camera_state = CameraState.FIXED
