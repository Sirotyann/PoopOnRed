extends Node2D

var StorageCLS = preload("res://general/storage.gd")
@onready var Storage = StorageCLS.new()

var index = 0

const loading = preload("res://scenes/general/loading.tscn")

@onready var Label1 = $Labels/Label_1
@onready var Label2 = $Labels/Label_2
@onready var Label3 = $Labels/Label_3
@onready var Label4 = $Labels/Label_4
@onready var Label5 = $Labels/Label_5
@onready var Label6 = $Labels/Label_6
@onready var Label7 = $Labels/Label_7

var text_speed = 1
var labels
var total_chars

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Storage.clear_status()
	TranslationServer.set_locale("zh")
	var is_first_time = Storage.get_is_first_time()
	
	if !is_first_time: 
		go_to_next()
	else:
		Storage.set_is_first_time(false)
		$Start.visible = false
		Label1.text = tr("INTRO_1")
		Label2.text = tr("INTRO_2")
		Label3.text = tr("INTRO_3")
		Label4.text = tr("INTRO_4")
		Label5.text = tr("INTRO_5")
		Label6.text = tr("INTRO_6")
		Label7.text = tr("INTRO_7")
		labels = [Label1, Label2, Label3, Label4, Label5, Label6, Label7]
		total_chars = [Label1.text.length(), Label2.text.length(), Label3.text.length(), Label4.text.length(), Label5.text.length(), Label6.text.length(), Label7.text.length()]
		
		for lbl in labels:
			lbl.visible_characters = 0
		
		$Timer.start()
		$TypingAudio.play()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
		$Start.visible = true
		
func go_to_next() -> void:
	print('goto MapSelection')
	var LoadingScene = loading.instantiate()
	add_child(LoadingScene)
	LoadingScene.switch_scence("res://scenes/maps/MapSelection.tscn")
	#get_tree().change_scene_to_file("res://scenes/maps/MapSelection.tscn")
