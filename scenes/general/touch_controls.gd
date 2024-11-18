extends CanvasLayer

@export var pooping := false

const Accuracy := 0.3

@onready var JoyStick = $HBoxContainer/JoyStick

func get_direction() -> Vector2:
	var direction = JoyStick.get_joystick_dir()
	var horizontal = 0 
	var vertical = 0
	if direction[0] < -Accuracy:
		horizontal = -1
	elif direction[0] > Accuracy:
		horizontal = 1
	
	if direction[1] < -Accuracy:
		vertical = -1
	elif direction[1] > Accuracy:
		vertical = 1
		
	return Vector2(horizontal, vertical)

func _on_shoot_pressed() -> void:
	pooping = true

func _on_shoot_released() -> void:
	pooping = false
