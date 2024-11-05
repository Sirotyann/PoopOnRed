extends CanvasLayer

@export var pooping := false

const Accuracy := 0.2

func get_direction() -> Vector2:
	var direction = $JoyStick.get_joystick_dir()
	var result = Vector2(0,0)
	if direction[0] < -Accuracy:
		result[0] = -1
	elif direction[0] > Accuracy:
		result[0] = 1
	
	if direction[1] < -Accuracy:
		result[1] = -1
	elif direction[0] > Accuracy:
		result[1] = 1	
		
	return result

func _on_shoot_pressed() -> void:
	pooping = true

func _on_shoot_released() -> void:
	pooping = false
