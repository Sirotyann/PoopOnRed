extends Node2D

@onready var QuitButton = $CanvasLayer/HBoxContainer2/Quit
@onready var HeroLabel = $CanvasLayer/Hero/Label

# Called when the node enters the scene tree for the first time.
func _ready():
	if Config.device == "iPhone":
		QuitButton.visible = false

	play_audio()
	$AudioStreamPlayer.connect("finished", self.play_audio)
	
	var time = Storage.instance.get_var('completed_dates').back()
	var hero_text = tr("BecomeHero")
	print(hero_text)
	HeroLabel.text = "{time}\n{content}".format({"time": time, "content": hero_text})
	
func play_audio():
	$AudioStreamPlayer.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func restart():
	get_tree().change_scene_to_file("res://scenes/maps/MapSelection.tscn")

func quit():
	get_tree().quit()
