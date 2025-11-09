@tool
class_name Goal
extends Node2D

signal real_goal_entered()

## Whether this is a real goal (which can trigger the next level) or a decoy
## goal. This setting is required or else and error will be thrown.
@export_enum("Unset:0", "Real Goal:1", "Decoy Goal:2") var goal_type: int
const UNSET = 0
const REAL = 1
const DECOY = 2

@export_range(1, 32) var particles_per_letter: int = 16

## The word that will appear in the game and which is intended to match the ball
## of that level. Fingers crossed that it updates automatically in the editor.
@export var word: String:
	set(value):
		word = value
		var rich_text_label = $Control/RichTextLabel
		if rich_text_label:
			rich_text_label.text = word

	
@onready var label: RichTextLabel = $Control/RichTextLabel
@onready var particles: CPUParticles2D = $Particles
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	if label:
		label.text = word
	if not Engine.is_editor_hint():
		GameStateService.game_state.connect(_on_game_state_change)

func _get_configuration_warnings():
	var warnings = []
	if goal_type == 0:
		warnings.append("You must set a goal type.")
	return warnings

func fade_out() -> void:
	particles.emitting = false
	animation_player.play("fade")
	pass

func _on_area_2d_body_entered(_body: Node2D):
	if goal_type == 1:
		print_debug("Real goal entered: %s" % label.text)
		real_goal_entered.emit()
	if goal_type == 2:
		print_debug("Decoy goal entered: %s" % label.text)
		fade_out()

func _on_game_state_change(state) -> void:
	# I don't want the particles to be affected by the engine time scale slowdown
	# during the success state, so this method adjusts the sprite emitter's speed
	# to compensate. It's necessary to wait for a frame ensure that the engine
	# time scale already been set to the slower speed.
	match state:
		Constants.GameState.SUCCESS:
			await get_tree().process_frame
			particles.speed_scale = 1.0 / Engine.time_scale
		_:
			particles.speed_scale = 1.0