extends Node

@export var levels: Array[PackedScene]

var current_level_index: int = 0
var current_level_instance: Node

func _ready():
	load_level(current_level_index)


func load_level(index: int):
	for child in $Level.get_children():
		child.queue_free()

	await get_tree().process_frame

	current_level_instance = levels[index].instantiate()
	$Level.add_child(current_level_instance)

	if current_level_instance.has_signal("start_game"):
		current_level_instance.start_game.connect(start_game)
	
	if current_level_instance.has_signal("play_again"):
		current_level_instance.play_again.connect(play_again)
	
	if current_level_instance.has_signal("success"):
		print_debug("Connected to success")
		current_level_instance.success.connect(next_level)


func next_level():
	current_level_index += 1
	if current_level_index < levels.size():
		load_level(current_level_index)
	else:
		print("All levels completed!")


func start_game():
	TimerService.start_short_timer()
	next_level()


func play_again():
	TimerService.reset()
	current_level_index = 0
	load_level(current_level_index)