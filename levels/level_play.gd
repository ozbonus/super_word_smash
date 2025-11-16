@tool
class_name GameLevel
extends Node2D

signal success
signal restart

@onready var operator_controls: OperatorControls = $OperatorControls

func _ready():
	if not Engine.is_editor_hint():
		for child in get_children():
			if child is Goal:
				var goal := child as Goal
				if goal.goal_type == Goal.TYPE_REAL:
					goal.real_goal_entered.connect(success.emit)
		if operator_controls:
			operator_controls.next_level.connect(func(): success.emit())
			operator_controls.restart.connect(func(): restart.emit())

func _get_configuration_warnings():
	var real_goals_count: int = 0
	var warnings = []

	for child in get_children():
		if child is Goal:
			var goal := child as Goal
			if goal.goal_type == Goal.TYPE_REAL:
				real_goals_count += 1

	if real_goals_count != 1:
		warnings.append("There must be exactly one real goal in this level.")
	
	if not operator_controls:
		warnings.append("You need to add an instance of OperatorControls.")

	return warnings