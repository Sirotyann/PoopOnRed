extends Node2D

var StorageCLS = preload("res://general/storage.gd")
@onready var Storage = StorageCLS.new()

const loading = preload("res://scenes/general/loading.tscn")

func _ready():
	#TranslationServer.set_locale("zh")
	$SunnyTown.refresh_text()
	$FoggyValley.refresh_text()
	$Quit.refresh_text()
	
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
