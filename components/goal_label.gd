@tool
class_name GoalLabel extends Node2D
@onready var label: RichTextLabel = $RichTextLabel
@onready var particles: CPUParticles2D = $Particles
@export var word: String = "debug":
	set(value):
		word = value
		if label:
			label.text = word
			particles.amount = particles_per_letter * word.length()
@export var emission_rect: Vector2 = Vector2(12.0, 20.0):
	set(value):
		emission_rect = value
		if particles:
			particles.emission_rect_extents = emission_rect
@export var particles_per_letter: int = 16:
	set(value):
		particles_per_letter = value
		if particles:
			particles.amount = particles_per_letter * word.length()


func _ready():
	if label:
		label.text = word
	if particles:
			particles.emission_rect_extents = emission_rect
			particles.amount = particles_per_letter * word.length()
	
	# This won't run in the editor.
	if not Engine.is_editor_hint():
		GameStateService.game_state.connect(_on_game_state_change)


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