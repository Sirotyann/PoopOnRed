extends Node2D

const loading = preload("res://scenes/general/loading.tscn")

@onready var Practice = $CanvasLayer/MainMenu/Practice
@onready var Firstshot = $CanvasLayer/Maps/Firstshot
@onready var SunnyTown = $CanvasLayer/Maps/SunnyTown
@onready var FoggyValley = $CanvasLayer/Maps/FoggyValley
@onready var ThreeVillages = $CanvasLayer/Maps/ThreeVillages
@onready var Oasis = $CanvasLayer/Maps/Oasis
@onready var Quit = $CanvasLayer/Quit
@onready var KeySettings = $CanvasLayer/KeySettings

var is_maps_manu_shown := false

var is_key_setting_shown := false

func _ready():
	#Storage.instance.clear_status()
	#Storage.instance.print_status()
	
	for bg in $CanvasLayer/HBoxContainer.get_children():
		bg.visible = false
	
	if Storage.instance.get_var("completed_times") <= 0:
		$CanvasLayer/HBoxContainer/Normal.visible = true
	elif Storage.instance.get_var("completed_times") == 1:
		$CanvasLayer/HBoxContainer/Complete1.visible = true
	elif Storage.instance.get_var("completed_times") == 2:
		$CanvasLayer/HBoxContainer/Complete2.visible = true
	elif Storage.instance.get_var("completed_times") == 3:
		$CanvasLayer/HBoxContainer/Complete3.visible = true
	elif Storage.instance.get_var("completed_times") >= 4:
		$CanvasLayer/HBoxContainer/Complete4.visible = true
	else:
		$CanvasLayer/HBoxContainer/Normal.visible = true
	
	if Config.device == "iPhone":
		Quit.visible = false
	
	play_bg_audio()
	$AudioStreamPlayer.connect('finished', self.play_bg_audio)
	
	$CanvasLayer/MapsBG.position.y = -550
	
	Firstshot.refresh_text()
	SunnyTown.refresh_text()
	FoggyValley.refresh_text()
	ThreeVillages.refresh_text()
	Oasis.refresh_text()
	Quit.refresh_text()

	if Storage.instance.get_var("is_firstshot_completed"):
		Firstshot.rainbow = true
		SunnyTown.disabled = false
	elif Storage.instance.get_var("firstshot_played") >= 1:
		SunnyTown.disabled = false
	
	if Storage.instance.get_var("is_town_completed"):
		FoggyValley.disabled = false
		SunnyTown.rainbow = true
	elif Storage.instance.get_var("town_played") >= Config.EnoughPracticeCount:
		FoggyValley.disabled = false

	if Storage.instance.get_var("is_valley_completed"):
		ThreeVillages.disabled = false
		FoggyValley.rainbow = true
	elif Storage.instance.get_var("valley_played") >= Config.EnoughPracticeCount:
		ThreeVillages.disabled = false
	
	if Storage.instance.get_var("is_village_completed"):
		Oasis.disabled = false
		ThreeVillages.rainbow = true
	elif Storage.instance.get_var("village_played") >= Config.EnoughPracticeCount:
		Oasis.disabled = false
	
	if Storage.instance.get_var("is_oasis_completed"):
		Oasis.rainbow = true
	
	Firstshot.refresh_style()
	SunnyTown.refresh_style()
	FoggyValley.refresh_style()
	ThreeVillages.refresh_style()
	Oasis.refresh_style()
	
	#Oasis.disabled = true
	#Oasis.refresh_style()

func toggle_practice_maps():
	if is_maps_manu_shown:
		$AnimationPlayer.play("hide_maps")
		is_maps_manu_shown = false
	else:
		$AnimationPlayer.play("show_maps")
		is_maps_manu_shown = true

func start_game():
	$AudioStreamPlayer.stop()
	General.mode = 'play'
	get_tree().change_scene_to_file("res://scenes/general/life.tscn")
	#var current_map = Storage.instance.get_var("playing_map")
	#var path = General.MapScenePath[current_map]
	#switch_scence(path)

func switch_to_practice():
	General.mode = 'practice'
	$AudioStreamPlayer.stop()
	switch_scence("res://scenes/maps/practice/practice.tscn")	
	
func switch_to_sunny_town():
	General.mode = 'practice'
	$AudioStreamPlayer.stop()
	switch_scence("res://scenes/maps/town/town.tscn")

func switch_to_foggy_valley():
	General.mode = 'practice'
	$AudioStreamPlayer.stop()
	switch_scence("res://scenes/maps/fog_valley/fog_valley.tscn")

func switch_to_three_villages():
	General.mode = 'practice'
	$AudioStreamPlayer.stop()
	switch_scence("res://scenes/maps/three_villages/three_villages.tscn")

func switch_to_oasis():
	General.mode = 'practice'
	$AudioStreamPlayer.stop()
	switch_scence("res://scenes/maps/oasis/oasis.tscn")

func switch_scence(path):
	var LoadingScene = loading.instantiate()
	add_child(LoadingScene)
	LoadingScene.switch_scence(path)

func quit():
	get_tree().quit()

func play_bg_audio():
	$AudioStreamPlayer.play()

func toggle_key_settings():
	if is_key_setting_shown:
		KeySettings.visible = false
		is_key_setting_shown = false
	else:
		KeySettings.visible = true
		is_key_setting_shown = true

func _on_key_settings_close() -> void:
	KeySettings.visible = false
	is_key_setting_shown = false
