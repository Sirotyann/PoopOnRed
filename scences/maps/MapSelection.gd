extends Node2D

const loading = preload("res://scences/general/loading.tscn")

var progress = []
var target_scence = null
var scene_load_status = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	TranslationServer.set_locale("zh")
	$SunnyTown.refresh_text()
	$FoggyValley.refresh_text()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target_scence != null:
		scene_load_status = ResourceLoader.load_threaded_get_status(target_scence, progress)
		$Loading.update_progress(progress[0])
		if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
			var new_scene = ResourceLoader.load_threaded_get(target_scence)
			get_tree().change_scene_to_packed(new_scene)

func on_button_down(e):
	print(e)

func switch_to_sunny_town():
	target_scence = "res://scences/maps/town/town.tscn"
	switch_scence()

func switch_to_foggy_valley():
	target_scence = "res://scences/maps/fog_valley/fog_valley.tscn"
	switch_scence()

func switch_scence():
	$Loading.visible = true
	ResourceLoader.load_threaded_request(target_scence)
