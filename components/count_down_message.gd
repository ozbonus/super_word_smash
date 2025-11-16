extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	visible = false


func play():
	visible = true
	animation_player.play("count_down")
	await animation_player.animation_finished
	visible = false

func play_count():
	SoundEffectsService.play_count()


func play_go():
	SoundEffectsService.play_go()