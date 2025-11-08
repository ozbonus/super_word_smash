@tool
class_name Goal
extends Node2D

signal real_goal_entered()

## Whether this is a real goal (which can trigger the next level) or a decoy
## goal. This setting is required or else and error will be thrown.
@export_enum("Unset:0", "Real Goal:1", "Decoy Goal:2") var goal_type: int

## The word that will appear in the game and which is intended to match the ball
## of that level. Fingers crossed that it updates automatically in the editor.
@export var word: String:
	set(value):
		word = value
		$Control/RichTextLabel.text = word
	
@onready var label: RichTextLabel = $Control/RichTextLabel
@onready var particles: CPUParticles2D = $Particles
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	if label:
		label.text = word

func _get_configuration_warnings():
	var warnings = []
	if goal_type == 0:
		warnings.append("You must set a goal type.")
	return warnings

func _on_area_2d_body_entered(_body: Node2D):
	if goal_type == 1:
		print_debug("Real goal entered: %s" % label.text)
		real_goal_entered.emit()
	if goal_type == 2:
		print_debug("Decoy goal entered: %s" % label.text)