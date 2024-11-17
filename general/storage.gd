extends Node
class_name Storage

var file_path_status := "user://status.dat"

var Empty_Status = {
	"is_first_time": true,
	"is_guide_played": false,
	"is_firstshot_completed": false,
	"firstshot_played": 0,
	"is_town_completed": false,
	"town_played": 0,
	"is_valley_completed": false,
	"valley_played": 0,
	"is_village_completed": false,
	"village_played": 0,
	"is_oasis_completed": false,
	"oasis_played": 0,
	"has_eaten": false,
	"has_poop_on_car": false,
	"playing_map": "firstshot",
	"completed_times": 0
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

func print_status():
	print("------ user status -----")
	print(get_status())
	print("------ ----- ----- -----")

func get_var(var_name):
	if(user_status == null): read_status()
	return user_status.get(var_name)

func set_var(key, val):
	if(user_status == null): read_status()
	user_status[key] = val
	save_status(user_status)

func complete_scene(scene):
	var var_name = "is_{scene}_completed".format({"scene": scene})
	set_var(var_name, true)

func complete_game():
	set_var("completed_times", get_var("completed_times") + 1)
	set_var("playing_map", General.map_queue[0])

### ---------------

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

func get_is_firstshot_completed():
	if(user_status == null): read_status()
	return user_status.is_firstshot_completed

func set_is_firstshot_completed(val):
	if(user_status == null): read_status()
	user_status.is_firstshot_completed = val
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

# --- map played times ---
func firstshot_played():
	user_status.firstshot_played = 1 if user_status.firstshot_played == null else user_status.firstshot_played + 1
	save_status(user_status)

func town_played():
	user_status.town_played = 1 if user_status.town_played == null else user_status.town_played + 1
	save_status(user_status)

func valley_played():
	user_status.valley_played = 1 if user_status.valley_played == null else user_status.valley_played + 1
	save_status(user_status)

func village_played():
	user_status.village_played = 1 if user_status.village_played == null else user_status.village_played + 1
	save_status(user_status)

func oasis_played():
	user_status.oasis_played = 1 if user_status.oasis_played == null else user_status.oasis_played + 1
	save_status(user_status)

func clear_status():
	#DirAccess.remove_absolute(file_path_status)
	print("Clear status")
	save_status(Empty_Status)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
