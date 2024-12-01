extends Node2D

#var Storage = preload("res://general/storage.gd")

var index = 0

const loading = preload("res://scenes/general/loading.tscn")

@onready var Label1 = $CanvasLayer/Labels/Label_1
@onready var Label2 = $CanvasLayer/Labels/Label_2
@onready var Label3 = $CanvasLayer/Labels/Label_3
@onready var Label4 = $CanvasLayer/Labels/Label_4
@onready var Label5 = $CanvasLayer/Labels/Label_5
#@onready var Label6 = $CanvasLayer/Labels/Label_6
#@onready var Label7 = $CanvasLayer/Labels/Label_7

@onready var StartButton = $CanvasLayer/HBoxContainer2/Start

var text_speed = 1
var labels
var total_chars

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var locale = OS.get_locale().to_lower()
	
	if locale.contains("zh"):
		TranslationServer.set_locale("zh")
	else:
		TranslationServer.set_locale("en")
	
	if Config.mode != "MOBILE":
		General.load_saved_keys()
	
	#Storage.instance.clear_status()
	#TranslationServer.set_locale("zh")
	
	#Storage.clear_status()
	#TranslationServer.set_locale("zh")
	#Storage.instance.set_is_first_time(true)
	
	var is_first_time = Storage.instance.get_is_first_time()
	
	if !is_first_time: 
		go_to_next()
	else:
		$PreLayer.visible = true
		$PreLayer/LabelContainer/Label.text = tr("PRE")
		$HidePreTimer.start()
		Storage.instance.set_is_first_time(false)
		#$Start.visible = false
		Label1.text = tr("INTRO_1")
		Label2.text = tr("INTRO_2")
		Label3.text = tr("INTRO_3")
		Label4.text = tr("INTRO_4")
		Label5.text = tr("INTRO_5")
		#Label6.text = tr("INTRO_6")
		#Label7.text = tr("INTRO_7")
		labels = [Label1, Label2, Label3, Label4, Label5]
		total_chars = [Label1.text.length(), Label2.text.length(), Label3.text.length(), Label4.text.length(), Label5.text.length()]
		
		for lbl in labels:
			lbl.visible_characters = 0
			
		StartButton.refresh_text()

func start_typing_info():
	$PreLayer.queue_free()
	$Timer.start()
	$TypingAudio.play()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	if index < labels.size():
		if labels[index].visible_characters < total_chars[index]:
			labels[index].visible_characters += text_speed
		else:
			index += 1
			$Timer.paused = true
			$TypingAudio.stop()
			await get_tree().create_timer(0.5).timeout
			$Timer.paused = false
			$TypingAudio.play()
	else:
		$Timer.stop()
		$TypingAudio.stop()
		StartButton.visible = true
		
func go_to_next() -> void:
	var LoadingScene = loading.instantiate()
	add_child(LoadingScene)
	LoadingScene.switch_scence("res://scenes/maps/MapSelection.tscn")

func hide_pre():
	var tween = get_tree().create_tween()
	tween.tween_property($PreLayer/LabelContainer, 'modulate:a', 0.0, 1)
	tween.tween_property($PreLayer/BGContainer, 'modulate:a', 0.0, 0.3)
	tween.tween_callback(start_typing_info)
