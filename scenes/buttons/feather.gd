extends Node2D

signal clicked

@export var key := ''
@export var disabled:bool :
	set(value):
		disabled = value

@export var color := 'white'


@export var rainbow:bool :
	set(value):
		rainbow = value

var textures = {
	"flat": {
		"light": "res://assets/images/buttons/feather.png",
		"dark":  "res://assets/images/buttons/feather_hover.png",
		"font_color": "#ff8d3a",
		"font_shadow": "#77422c",
	},
	"white": {
		"light": "res://assets/images/buttons/feather_white.png",
		"dark":  "res://assets/images/buttons/feather_light_grey.png",
		"font_color": "#ff8d3a",
		"font_shadow": "#77422c",
	},
	"red": {
		"light": "res://assets/images/buttons/feather_red.png",
		"dark": "res://assets/images/buttons/feather_red_grey.png",
		"font_color": "#fffd5c",
		"font_shadow": "#d3d256",
	},
	"yellow": {
		"light": "res://assets/images/buttons/feather_yellow.png",
		"dark": "res://assets/images/buttons/feather_yellow_grey.png",
		"font_color": "#2379fa",
		"font_shadow": "#1d6bdf",
	},
	"blue": {
		"light": "res://assets/images/buttons/feather_blue.png",
		"dark": "res://assets/images/buttons/feather_blue_grey.png",
		"font_color": "#d2ff00",
		"font_shadow": "#abc33a",
	},
	"green": {
		"light": "res://assets/images/buttons/feather_green.png",
		"dark": "res://assets/images/buttons/feather_green_grey.png",
		"font_color": "#fb539e",
		"font_shadow": "#d94688",
	},
	"purple": {
		"light": "res://assets/images/buttons/feather_purple.png",
		"dark": "res://assets/images/buttons/feather_purple_grey.png",
		"font_color": "#79fffd",
		"font_shadow": "#6fe5e3",
	},
	"cyan": {
		"light": "res://assets/images/buttons/feather_cyan.png",
		"dark": "res://assets/images/buttons/feather_cyan_grey.png",
		"font_color": "#ff45f0",
		"font_shadow": "#d037c3",
	},
	"disabled": {
		"light": "res://assets/images/buttons/feather_grey.png",
		"dark":  "res://assets/images/buttons/feather_grey.png",
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
	
	var light_texture = load(textures[_color].light)
	var dark_texture = load(textures[_color].dark)
	
	$TextureButton.texture_normal = dark_texture
	$TextureButton.texture_hover = light_texture
	
	$TextureButton/Label.add_theme_color_override("font_color", textures[_color].font_color);
	#$TextureButton/Label.add_theme_color_override("font_shadow_color", textures[_color].font_shadow);
	
	if disabled: 
		$stop.visible = true
	else:
		$stop.visible = false
	
	if rainbow: 
		$rainbow.visible = true
	else:
		$rainbow.visible = false

func refresh_text():
	$TextureButton/Label.text = tr(key)

func _on_button_down() -> void:
	if !disabled:
		$TextureButton.position.y += 3
		$TextureButton.position.x += 3

func _on_button_up() -> void:
	if !disabled or Config.device == 'iPhone':
		$TextureButton.position.y -= 3
		$TextureButton.position.x -= 3
		clicked.emit()
