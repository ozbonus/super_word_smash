extends Node2D

@onready var particles: CPUParticles2D = $Particles


# Called when the node enters the scene tree for the first time.
func _ready():
	$Particles.process_mode = Node.PROCESS_MODE_ALWAYS


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
