extends Label

"""
A simple label for showing the current accelerometer and gravity data. Updates
in real time. Shows magnitude.
"""

func _ready() -> void:
	pass

func _process(_delta) -> void:
	var acceleration: Vector3 = Input.get_accelerometer()
	var magnitude: float = acceleration.length()

	var output: String = "Acceleration: %s\nMagnitude: %s"
	text = output % [acceleration, magnitude]