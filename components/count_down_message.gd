extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func play():
	animation_player.play("count_down")

func play_count():
	SoundEffectsService.play_count()

func play_go():
	SoundEffectsService.play_go()