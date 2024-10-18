extends Node2D

const loading = preload("res://scences/general/loading.tscn")

func _ready():
	TranslationServer.set_locale("zh")
	$SunnyTown.refresh_text()
	$FoggyValley.refresh_text()
	$Quit.refresh_text()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_button_down(e):
	print(e)

func switch_to_sunny_town():
	switch_scence("res://scences/maps/town/town.tscn")

func switch_to_foggy_valley():
	switch_scence("res://scences/maps/fog_valley/fog_valley.tscn")

func switch_scence(path):
	var LoadingScene = loading.instantiate()
	add_child(LoadingScene)
	LoadingScene.switch_scence(path)

func quit():
	get_tree().quit()
