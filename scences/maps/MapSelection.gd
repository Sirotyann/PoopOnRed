extends Node2D
#
#const square_town_scence = preload("res://scences/maps/town/town.tscn")
#const fog_valley_scence = preload("res://scences/maps/fog_valley/fog_valley.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	TranslationServer.set_locale("zh")
	$SunnyTown.refresh_text()
	$FoggyValley.refresh_text()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_button_down(e):
	print(e)


func switch_to_sunny_town():
	get_tree().change_scene_to_file("res://scences/maps/town/town.tscn")

func switch_to_foggy_valley():
	get_tree().change_scene_to_file("res://scences/maps/fog_valley/fog_valley.tscn")
