class_name OperatorControls
extends CanvasLayer

signal next_level
signal restart

@onready var open_button: Button = %OpenButton
@onready var button_container: CenterContainer = %ButtonContainer
@onready var next_level_button: Button = %NextLevelButton
@onready var restart_button: Button = %RestartButton
@onready var close_button: Button = %CloseButton


func _ready():
	button_container.visible = false


func _on_open_button_pressed():
	button_container.visible = true


func _on_next_level_button_pressed():
	next_level.emit()


func _on_restart_button_pressed():
	restart.emit()


func _on_close_button_pressed():
	button_container.visible = false