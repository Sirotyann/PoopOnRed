extends Node3D

const Veichle_Speed := 3.0
const Veichle_Total_Count := 200

var PathDispatcher = preload("res://general/path_dispatcher.gd")

# Vehicles
var Delivery = preload("res://scences/kit/cars/delivery.tscn")
var SUVWhite = preload("res://scences/kit/cars/suv_white.tscn")
var Sedan = preload("res://scences/kit/cars/sedan-sports.tscn")
var SUV = preload("res://scences/kit/cars/suv_luxury.tscn")
var Texi = preload("res://scences/kit/cars/taxi.tscn")
var Truck = preload("res://scences/kit/cars/truck.tscn")
var Van = preload("res://scences/kit/cars/van.tscn")
var Hatchback = preload("res://scences/kit/cars/hatchback_sports.tscn")

var passed_time := 0
var timer
var path_dispatcher
var cars_to_add = []

@onready var Veichle_Models = [Sedan, Delivery, SUV, Texi, Truck, Van, Hatchback]

# Called when the node enters the scene tree for the first time.
func _ready():
	#$BuildingMap.get_child(0).connect("")
	timer = Timer.new()
	timer.wait_time = 1.0
	timer.connect('timeout', self.one_sec_passed)
	add_child(timer)
	timer.start()
	
	var suv_white = SUVWhite.instantiate()
	
	for n in Veichle_Total_Count:
		var index = randi_range(0, Veichle_Models.size() - 1)
		var model = Veichle_Models[index]
		cars_to_add.push_back(model.instantiate())
	
	path_dispatcher = PathDispatcher.new()
	path_dispatcher.init($Paths.get_children(), [suv_white], Veichle_Speed)
	add_child(path_dispatcher)
	
	#$Container/seagull/Camera3D.current = false
	
func one_sec_passed():
	var car = cars_to_add.pop_back()
	if car != null: 
		path_dispatcher.add_item(car)
	
func _process(delta):
	#for path_follow in path_follows:
		#path_follow.progress += delta * Veichle_Speed
	pass
