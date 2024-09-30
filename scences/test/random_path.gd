extends Node3D

var PathDispatcher = preload("res://general/path_dispatcher.gd")

var Delivery = preload("res://scences/kit/cars/delivery.tscn")
var SUVWhite = preload("res://scences/kit/cars/suv_white.tscn")
var Sedan = preload("res://scences/kit/cars/sedan-sports.tscn")
var SUV = preload("res://scences/kit/cars/suv_luxury.tscn")
var Texi = preload("res://scences/kit/cars/taxi.tscn")
var Truck = preload("res://scences/kit/cars/truck.tscn")
var Van = preload("res://scences/kit/cars/van.tscn")

@onready var paths = [$Path3D, $Path3D2, $Path3D3]
@onready var Veichle_Models = [ Delivery, SUV ]

const Veichle_Speed := 13.0
const Veichle_Total_Count := 10

var follows = []

var current_path_follow = null

var timer
var cars_to_add = []
var path_dispatcher

# Called when the node enters the scene tree for the first time.
func _ready():	
	for n in Veichle_Total_Count:
		var index = randi_range(0, Veichle_Models.size() - 1)
		var model = Veichle_Models[index]
		cars_to_add.push_back(model.instantiate())
	
	path_dispatcher = PathDispatcher.new()
	path_dispatcher.init([$Path3D, $Path3D2], cars_to_add, Veichle_Speed)
	add_child(path_dispatcher)
	pass
	
## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#$Path3D/PathFollow3D.progress += delta * Veichle_Speed
	pass
				
#func add_car():
	#var car = cars_to_add.pop_back()
	#if car != null: 
		#path_dispatcher.add_item(car)
	#
	
#func get_follow_from_path(path):
	#var children = path.get_children()
	##print(children)
	#return children[0]
	#
#func add_follow_path(path):
	#var follow = PathFollow3D.new()
	#follow.add_child(suv_0)
	#path.add(follow)
	#follows.add(follow)
#
#func follow_random_path(car, paths):
	#var index = randi_range(0, paths.size() - 1)
	#print('follow path %s' % index)
	#var follow = paths[index].get_children()[0]
	#follow.add_child(car)
	#current_path_follow = follow
	#
#func remove_children(item):
	#var children = item.get_children()
	#for child in children:
		#item.remove_child(child)
#
