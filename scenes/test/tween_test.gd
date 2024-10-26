extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = create_tween()
	#tween.tween_property($Sprite2D, "scale", Vector2(0, 0), 1)
	tween.tween_property($Sprite2D, "modulate:a", 0.0, 1)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
