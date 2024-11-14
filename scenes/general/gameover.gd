extends Node2D

var Settings = preload("res://settings.gd")

@onready var QuitButon = $CanvasLayer/VBoxContainer/Quit

# Called when the node enters the scene tree for the first time.
func _ready():
	if Settings.device == "iPhone":
		QuitButon.visible = false
		
	play_audio()
	$AudioStreamPlayer.connect("finished", self.play_audio)

func play_audio():
	$AudioStreamPlayer.play()

func restart():
	get_tree().change_scene_to_file("res://scenes/maps/MapSelection.tscn")

func quit():
	get_tree().quit()
