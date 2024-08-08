extends Node3D

const Veichle_Speed := 3.0

var delivery_truck = preload("res://scences/kit/cars/delivery.tscn")
var white_suv = preload("res://scences/kit/cars/suv_white.tscn")

var passed_time := 0
var timer

var path_follows := []

# Called when the node enters the scene tree for the first time.
func _ready():
	#$BuildingMap.get_child(0).connect("")
	timer = Timer.new()
	timer.wait_time = 1.0
	timer.connect('timeout', self.one_sec_passed)
	add_child(timer)
	timer.start()

func one_sec_passed():
	passed_time += 1
	if passed_time == 1:
		add_car_to_path(white_suv.instantiate(), $Path3D)
	if passed_time == 10: 
		add_car_to_path(delivery_truck.instantiate(), $Path3D)

func add_delivery_truck():
	var delivery_truck_instance = delivery_truck.instantiate()
	var delivery_truck_follow = PathFollow3D.new()
	delivery_truck_follow.add_child(delivery_truck_instance)
	$Path3D.add_child(delivery_truck_follow)
	path_follows.push_back(delivery_truck_follow)
	#add_child(delivery_truck_instance)

func add_suv():
	var white_suv_instance = white_suv.instantiate()
	white_suv_instance.rotation.y = deg_to_rad(-180)
	var white_suv_follow = PathFollow3D.new()
	white_suv_follow.add_child(white_suv_instance)
	$Path3D.add_child(white_suv_follow)
	path_follows.push_back(white_suv_follow)


func add_car_to_path(car_instance, path):
	car_instance.rotation.y = deg_to_rad(-180)
	var car_path_follow = PathFollow3D.new()
	car_path_follow.add_child(car_instance)
	path.add_child(car_path_follow)
	path_follows.push_back(car_path_follow)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for path_follow in path_follows:
		path_follow.progress += delta * Veichle_Speed

func _on_building_map_child_entered_tree(node):
	print('build collision')
	pass # Replace with function body.
