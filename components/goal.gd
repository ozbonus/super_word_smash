class_name Goal extends Node2D

signal entered

enum GoalType { UNSET, REAL, DECOY }

## Whether this is a real goal (which can trigger the next level) or a decoy
## goal. This setting is required or else and error will be thrown.
@export var goal_type: GoalType

func _ready():
	if goal_type == GoalType.UNSET:
		push_error("You must define a goal type.")
		return


func _on_area_2d_body_entered():
	entered.emit()
