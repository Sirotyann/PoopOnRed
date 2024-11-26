extends Node2D

const loading = preload("res://scenes/general/loading.tscn")

@onready var label = $CanvasLayer/CenterBox/Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var life = Storage.instance.get_var("life")
	label.text = "x {val}".format({"val": life})
	$Timer.start()
	
func _on_timer_timeout() -> void:
	var current_map = Storage.instance.get_var("playing_map")
	var path = General.MapScenePath[current_map]
	switch_scence(path)

func switch_scence(path):
	var LoadingScene = loading.instantiate()
	add_child(LoadingScene)
	LoadingScene.switch_scence(path)
