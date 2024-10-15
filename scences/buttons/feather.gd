extends Node2D

signal clicked

@export var key := ''

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TextureButton.connect("button_down", self._on_button_down)
	$TextureButton.connect("button_up", self._on_button_up)
	$TextureButton/Label.text = tr(key)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func refresh_text():
	$TextureButton/Label.text = tr(key)

func _on_button_down() -> void:
	$TextureButton.position.y += 3
	$TextureButton.position.x += 3

func _on_button_up() -> void:
	$TextureButton.position.y -= 3
	$TextureButton.position.x -= 3
	clicked.emit()
