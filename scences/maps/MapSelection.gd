extends Node2D
#
#const square_town_scence = preload("res://scences/maps/town/town.tscn")
#const fog_valley_scence = preload("res://scences/maps/fog_valley/fog_valley.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$square_town.connect('pressed', switch_to_square_town)
	$fog_valley.connect('pressed', switch_to_fog_valley)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func switch_to_square_town():
	get_tree().change_scene_to_file("res://scences/maps/town/town.tscn")

func switch_to_fog_valley():
	get_tree().change_scene_to_file("res://scences/maps/fog_valley/fog_valley.tscn")
