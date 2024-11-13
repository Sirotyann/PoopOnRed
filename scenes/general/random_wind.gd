extends Node3D

class_name RandomWind


static var instance := RandomWind.new()

var timer:Timer
var rng = RandomNumberGenerator.new()

const min_time := 3.0
const max_time := 8.0

const min_vx := 0.5
const max_vx := 2.0

const min_vz := 0.5
const max_vz := 2.0

signal wind_change

var current_wind := Vector3(0.0, 0.0, 0.0)

func start():
	if timer == null:
		timer = Timer.new()
		timer.wait_time = rng.randf_range(min_time, max_time)
		print("Random wind start  ", timer.wait_time)
		timer.connect('timeout', on_timeout)
		add_child(timer)
		timer.start()

func on_timeout():
	if(rng.randf_range(0.0, 1.0) > 0.80):
		current_wind = Vector3(0.0, 0.0, 0.0)
	else:
		var vx = get_random_velocity(min_vx, max_vx)
		var vz = get_random_velocity(min_vz, max_vz)
		current_wind = Vector3(vx, 0.0, vz)
	
	refresh_timer()
	wind_change.emit()

func get_random_velocity(min, max):
	var v = rng.randf_range(min, max)
	if(rng.randf_range(0.0, 1.0) > 0.5):
		return -v
	else:
		return v

func get_wind():
	return current_wind

func refresh_timer():
	timer.wait_time = rng.randf_range(min_time, max_time)
	timer.start()
