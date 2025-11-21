# This script is used for every level in the game! It's marked with @tool so
# that it can help check if the level is set up correctly even before you run
# the game. It also connects all the important pieces together, like telling
# the game when the player wins by getting the ball into the correct goal.

@tool
class_name GameLevel
extends Node2D

signal success ## Sent out when the ball enters the real goal and you win!
signal restart ## Sent out when clicking the button to restart the game.

@onready var operator_controls: OperatorControls = $OperatorControls


func _ready():
    # Only run this code when actually playing the game, not while editing it.
    if not Engine.is_editor_hint():
        # Look through all the things in this level (goals, balls, walls, etc.)
        for child in get_children():
            # Find any goals in the level.
            if child is Goal:
                var goal := child as Goal
                # If it's the real goal (not a decoy), connect its signal.
                # This means when the ball enters the real goal, this level
                # will send out a "success" signal to tell the game you've
                # beaten this level.
                if goal.goal_type == Goal.TYPE_REAL:
                    goal.real_goal_entered.connect(success.emit)
        
        # Connect the operator controls (special buttons that appear in-game).
        if operator_controls:
            # These let you skip to the next level if something goes wrong
            # (like the ball getting stuck), or restart the entire game from
            # the beginning if needed.
            operator_controls.next_level.connect(func(): success.emit())
            operator_controls.restart.connect(func(): restart.emit())


# This special function runs in the editor and checks if the level is set up
# correctly. If something is wrong, it shows a warning in the editor so you know
# what to fix.
func _get_configuration_warnings():
    var real_goals_count: int = 0
    var warnings = []

    # Count how many real goals exist in this level.
    for child in get_children():
        if child is Goal:
            var goal := child as Goal
            if goal.goal_type == Goal.TYPE_REAL:
                real_goals_count += 1

    # Every level needs exactly one real goal - not zero, not two, just one.
    if real_goals_count != 1:
        warnings.append("There must be exactly one real goal in this level.")
    
    # Every level needs the operator controls for emergency situations.
    if not operator_controls:
        warnings.append("You need to add an instance of OperatorControls.")

    return warnings