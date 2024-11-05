extends Node2D

signal clicked

@export var key := ''
@export var disabled:bool :
	set(value):
		disabled = value

@export var color := 'white'

var is_disabled:bool

var textures = {
	"white": {
		"light": "res://assets/images/buttons/feather_white.png",
		"dark":  "res://assets/images/buttons/feather_grey.png",
		"font_color": "#ff8d3a",
		"font_shadow": "#77422c",
	},
	"red": {
		"light": "res://assets/images/buttons/feather_red.png",
		"dark": "res://assets/images/buttons/feather_red_dark.png",
		"font_color": "#ffffff",
		"font_shadow": "#666666",
	},
	"yellow": {
		"light": "res://assets/images/buttons/feather_yellow.png",
		"dark": "res://assets/images/buttons/feather_yellow_dark.png",
		"font_color": "#c40079",
		"font_shadow": "#641a2a",
	},
	"disabled": {
		"light": "res://assets/images/buttons/feather_dark_grey.png",
		"dark":  "res://assets/images/buttons/feather_dark_grey.png",
		"font_color": "#857a67",
		"font_shadow": "#716857",
	}
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TextureButton.connect("button_down", self._on_button_down)
	$TextureButton.connect("button_up", self._on_button_up)
	refresh_text()
	refresh_style()
	
func refresh_style():
	var _color = "disabled" if disabled else color
	#var light_image = load(textures[_color].light) #Image.load_from_file(textures[_color].light)
	var light_texture = load(textures[_color].light) #ImageTexture.create_from_image(light_image)
	#var dark_image = load(textures[_color].dark) #Image.load_from_file(textures[_color].dark)
	var dark_texture = load(textures[_color].dark) #ImageTexture.create_from_image(dark_image)
	
	$TextureButton.texture_normal = dark_texture
	$TextureButton.texture_hover = light_texture
	
	$TextureButton/Label.add_theme_color_override("font_color", textures[_color].font_color);
	$TextureButton/Label.add_theme_color_override("font_shadow_color", textures[_color].font_shadow);

func refresh_text():
	$TextureButton/Label.text = tr(key)

func _on_button_down() -> void:
	if !disabled:
		$TextureButton.position.y += 3
		$TextureButton.position.x += 3

func _on_button_up() -> void:
	if !disabled:
		$TextureButton.position.y -= 3
		$TextureButton.position.x -= 3
		clicked.emit()
