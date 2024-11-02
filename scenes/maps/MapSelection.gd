extends Node2D

var Storage = preload("res://general/storage.gd")

const loading = preload("res://scenes/general/loading.tscn")

func _ready():
	#TranslationServer.set_locale("zh")
	play_bg_audio()
	$AudioStreamPlayer.connect('finished', self.play_bg_audio)
	
	$SunnyTown.refresh_text()
	$FoggyValley.refresh_text()
	$Quit.refresh_text()

	#Storage.clear_status()
	
	if Storage.instance.get_is_practice_completed():
		$SunnyTown.disabled = false
		$SunnyTown.refresh_style()
		
	if Storage.instance.get_is_town_completed():
		$FoggyValley.disabled = false
		$FoggyValley.refresh_style()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func switch_to_practice():
	$AudioStreamPlayer.stop()
	switch_scence("res://scenes/maps/practice/practice.tscn")	
	
func switch_to_sunny_town():
	$AudioStreamPlayer.stop()
	switch_scence("res://scenes/maps/town/town.tscn")

func switch_to_foggy_valley():
	$AudioStreamPlayer.stop()
	switch_scence("res://scenes/maps/fog_valley/fog_valley.tscn")

func switch_scence(path):
	var LoadingScene = loading.instantiate()
	add_child(LoadingScene)
	LoadingScene.switch_scence(path)

func quit():
	get_tree().quit()

func play_bg_audio():
	$AudioStreamPlayer.play()
