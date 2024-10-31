extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	play_audio()
	$AudioStreamPlayer.connect("finished", self.play_audio)

func play_audio():
	$AudioStreamPlayer.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func restart():
	get_tree().change_scene_to_file("res://scenes/maps/MapSelection.tscn")

func quit():
	get_tree().quit()
