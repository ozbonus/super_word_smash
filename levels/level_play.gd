extends Node2D

signal success

@export var goal: Goal

# Called when the node enters the scene tree for the first time.
func _ready():
	goal.entered.connect(func(): success.emit())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass