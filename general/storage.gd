extends Node

var file_path := "user://user_status"

var is_first_time := true
var is_town_completed := false
var is_valley_completed := false
var has_eaten := false
var has_poop_on_car := false
	
func read_var(variabel):
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		return file.get_var(variabel)
	else:
		return variabel

func write_var(variable):
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	file.store_var(variable)
	
func get_is_first_time():
	is_first_time = read_var(is_first_time)
	return is_first_time

func set_is_first_time(val):
	is_first_time = val
	write_var(is_first_time)

func get_is_town_completed():
	return read_var(is_town_completed)

func town_completed():
	is_town_completed = true
	write_var(is_town_completed)

func clear_status():
	DirAccess.remove_absolute(file_path)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


#func save_score():
	#var file = FileAccess.open(data_path, FileAccess.WRITE)
	#file.store_var(score)
#
#func read_score():
	#if FileAccess.file_exists(data_path):
		#var file = FileAccess.open(data_path, FileAccess.READ)
		#var score_pre = file.get_var(score)
		#print(score_pre)
		#return score_pre
	#else:
		#print('cannot read data')
		#return 0
