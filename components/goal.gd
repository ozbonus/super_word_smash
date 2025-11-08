@tool
class_name Goal
extends Node2D

signal entered(type: GoalType)

enum GoalType { UNSET, REAL, DECOY }

## Whether this is a real goal (which can trigger the next level) or a decoy
## goal. This setting is required or else and error will be thrown.
@export var goal_type: GoalType

## The word that will appear in the game and which is intended to match the ball
## of that level. Fingers crossed that it updates automatically in the editor.
@export var word: String:
	set(value):
		word = value
		$Label.text = word

func _get_configuration_warnings():
	var warnings = []
	if goal_type == GoalType.UNSET:
		warnings.append("You must set a goal type.")
	if not has_node("Area2D"):
		warnings.append("This node requires an Area2D child node.")
	if not has_node("Label"):
		warnings.append("This node requires a Label child node.")
	return warnings


func _ready():
	pass

func _on_area_2d_body_entered(_body: Node2D):
	if goal_type == GoalType.REAL:
		entered.emit(goal_type)
