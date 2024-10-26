extends Node3D

var sedan_sports = preload("res://scenes/kit/cars/sedan-sports.tscn")

var paused_path_follows := {}

var second_follow = null

# Called when the node enters the scene tree for the first time.
func _ready():
	var timer = Timer.new()
	timer.one_shot = true
	timer.connect('timeout', add_sedan)
	timer.wait_time = 1.0
	add_child(timer)
	timer.start()
	
	$Path3D/PathFollow3D/suv.connect("should_stop", stop_car.bind($Path3D/PathFollow3D))
	#$"Path3D/PathFollow3D2/sedan-sports".connect("should_stop", stop_car.bind($Path3D/PathFollow3D2))
	#$"Path3D2/PathFollow3D/sedan-sports".connect("should_stop", stop_car.bind($Path3D2/PathFollow3D))

func add_sedan():
	var sedan = sedan_sports.instantiate()
	var sedan_follow = PathFollow3D.new()
	sedan_follow.add_child(sedan)
	second_follow = sedan_follow
	$Path3D.add_child(sedan_follow)
	sedan.connect("should_stop", stop_car.bind(second_follow))

func stop_car(follow):
	print(follow)
	paused_path_follows[follow.get_instance_id()] = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var speed = 5.0

	if !paused_path_follows.has($Path3D/PathFollow3D.get_instance_id()):
		$Path3D/PathFollow3D.progress += delta * speed
	#if !paused_path_follows.has($Path3D/PathFollow3D2.get_instance_id()):
		#$Path3D/PathFollow3D2.progress += delta * speed
	#if !paused_path_follows.has($Path3D2/PathFollow3D.get_instance_id()):
		#$Path3D2/PathFollow3D.progress += delta * speed
	if second_follow != null and !paused_path_follows.has(second_follow.get_instance_id()):
		#print('should skip 2nd follow')
		#print(second_follow)
		#print(paused_path_follows.has(second_follow))
		second_follow.progress += delta * (speed + 2.0)
