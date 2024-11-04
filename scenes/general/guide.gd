extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("click"):
		next_step()

func next_step():
	print('next step')

func _on_button_pressed() -> void:
	print('next')
	pass # Replace with function body.
