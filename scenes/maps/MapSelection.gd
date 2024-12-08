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

var _appstore = null

func _ready():
	#Storage.instance.clear_status()
	if Config.device == "iPhone":
		Quit.visible = false
		#init_inappstore()
		
	if Config.mode == "MOBILE":
		$CanvasLayer/SettingsBox.visible = false
	
	for bg in $CanvasLayer/HBoxContainer.get_children():
		bg.visible = false
	
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
	
	# in app purchase
	if Config.device == 'iPhone':
		SunnyTown.disabled = false
		FoggyValley.disabled = !Storage.instance.get_var("pooponred_foggy_valley")
		ThreeVillages.disabled = !Storage.instance.get_var("pooponred_three_village")
		Oasis.disabled = !Storage.instance.get_var("pooponred_oasis")
	
	Firstshot.refresh_style()
	SunnyTown.refresh_style()
	FoggyValley.refresh_style()
	ThreeVillages.refresh_style()
	Oasis.refresh_style()
	
	show_glory()
	
	#Oasis.disabled = true
	#Oasis.refresh_style()

#func init_inappstore():
	#print('init_inappstore')
	#if Engine.has_singleton("InAppStore"):
		#print("Init inappstore")
		#_appstore = Engine.get_singleton('InAppStore')
		#var result = _appstore.request_product_info({ "product_ids": ["pooponred_foggy_valley", "pooponred_three_village", "pooponred_oasis"] })
		#print(result)
		

func show_glory():
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
	
	if Storage.instance.get_var("completed_times") > 0 and len(Storage.instance.get_var("completed_dates")) > 0:
		$CanvasLayer/GloryContainer.visible = true
		$CanvasLayer/GloryContainer/GloryMoment.text = tr("GloryMoment")
		var moments = Storage.instance.get_var("completed_dates")
		moments.reverse()
		for index in min(len(moments), 9):
			var label = $CanvasLayer/GloryContainer/Label.duplicate()
			if len(moments) > 9 and index == 8:
				label.text = "......"
			else:
				label.text = moments[index]
			$CanvasLayer/GloryContainer.add_child(label)
			label.visible = true
			
	else:
		$CanvasLayer/GloryContainer.visible = false

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
	if Config.device == 'iPhone' and !Storage.instance.get_var("pooponred_foggy_valley"):
		go_shopping()
	else:
		General.mode = 'practice'
		$AudioStreamPlayer.stop()
		switch_scence("res://scenes/maps/fog_valley/fog_valley.tscn")

func switch_to_three_villages():
	if Config.device == 'iPhone' and !Storage.instance.get_var("pooponred_three_village"):
		go_shopping()
	else:
		General.mode = 'practice'
		$AudioStreamPlayer.stop()
		switch_scence("res://scenes/maps/three_villages/three_villages.tscn")

func switch_to_oasis():
	if Config.device == 'iPhone' and !Storage.instance.get_var("pooponred_oasis"):
		go_shopping()
	else:
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

func go_shopping() -> void:
	switch_scence("res://scenes/inappstore/purchase.tscn")
