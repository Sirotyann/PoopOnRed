extends Node
class_name Storage

var file_path_status := "user://status.dat"

var Empty_Status = {
	"is_first_time": true,
	"is_practice_completed": false,
	"is_town_completed": false,
	"is_valley_completed": false,
	"has_eaten": false,
	"has_poop_on_car": false	
}

static var instance := Storage.new()

var user_status:
	set(val):
		user_status = val

func read_status():
	var _status = Empty_Status
	if FileAccess.file_exists(file_path_status):
		var file = FileAccess.open(file_path_status, FileAccess.READ)
		var json_string = file.get_as_text()
		var json = JSON.new()
		var error = json.parse(json_string)
		if error == OK:
			var data_received = json.data
			_status = data_received
		else:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
	user_status = _status

func save_status(status):
	user_status = status
	var json_string = JSON.stringify(status)
	var file = FileAccess.open(file_path_status, FileAccess.WRITE)
	file.store_string(json_string)

func get_status():
	return user_status

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	read_status()

func get_is_first_time():
	if(user_status == null): read_status()
	return user_status.is_first_time

func set_is_first_time(val):
	user_status.is_first_time = val
	save_status(user_status)

func get_is_town_completed():
	if(user_status == null): read_status()
	return user_status.is_town_completed

func set_is_town_completed(val):
	user_status.is_town_completed = val
	save_status(user_status)

func get_is_valley_completed():
	if(user_status == null): read_status()
	return user_status.is_valley_completed

func set_is_valley_completed(val):
	user_status.is_valley_completed = val
	save_status(user_status)
	
func get_is_practice_completed():
	if(user_status == null): read_status()
	return user_status.is_practice_completed

func set_is_practice_completed(val):
	if(user_status == null): read_status()
	user_status.is_practice_completed = val
	save_status(user_status)

func get_has_eaten():
	if(user_status == null): read_status()
	return user_status.has_eaten

func set_has_eaten(val):
	user_status.has_eaten = val
	save_status(user_status)

func get_has_poop_on_car():
	if(user_status == null): read_status()
	return user_status.has_poop_on_car

func set_has_poop_on_car(val):
	user_status.has_poop_on_car = val
	save_status(user_status)

func clear_status():
	#DirAccess.remove_absolute(file_path_status)
	print("Clear status")
	save_status(Empty_Status)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
