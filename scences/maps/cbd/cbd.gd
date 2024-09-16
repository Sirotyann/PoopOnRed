extends Node3D

const Veichle_Speed := 5.2
const Veichle_Total_Count := 10

var PathDispatcher = preload("res://general/path_dispatcher.gd")

# Vehicles
const Delivery = preload("res://scences/kit/cars/delivery.tscn")
const SUVWhite = preload("res://scences/kit/cars/suv_white.tscn")
const Sedan = preload("res://scences/kit/cars/sedan-sports.tscn")
const SUV = preload("res://scences/kit/cars/suv_luxury.tscn")
const Texi = preload("res://scences/kit/cars/taxi.tscn")
const Truck = preload("res://scences/kit/cars/truck.tscn")
const Van = preload("res://scences/kit/cars/van.tscn")

# Food
const Cake = preload("res://scences/kit/food/cake.tscn")
const Apple = preload("res://scences/kit/food/apple.tscn")
const Burger = preload("res://scences/kit/food/burger.tscn")
const Coissant = preload("res://scences/kit/food/croissant.tscn")
const Donut = preload("res://scences/kit/food/donut.tscn")
const Fires = preload("res://scences/kit/food/fries.tscn")
const Hotdog = preload("res://scences/kit/food/hot_dog.tscn")
const Pizza = preload("res://scences/kit/food/pizza.tscn")
const Taco = preload("res://scences/kit/food/taco.tscn")

var passed_time := 0
var timer
var path_dispatcher
var cars_to_add = []

@onready var Veichle_Models = [Delivery, SUV, Texi, Truck, Van, SUVWhite]
@onready var Fantacy_Food_Models = [Cake, Burger, Pizza]
@onready var Fantacy_Food_Model_COORDS = [$Container/FoodCoords/Marker01, $Container/FoodCoords/Marker02, $Container/FoodCoords/Marker03]
@onready var Normal_Food_Models = [Apple, Coissant, Donut, Fires, Hotdog, Taco, Fires, Pizza]
@onready var Normal_Food_Model_COORDS = [
	$Container/FoodCoords/Marker04, $Container/FoodCoords/Marker05, $Container/FoodCoords/Marker06,
	$Container/FoodCoords/Marker07, $Container/FoodCoords/Marker08, $Container/FoodCoords/Marker09,
	$Container/FoodCoords/Marker10, $Container/FoodCoords/Marker11, $Container/FoodCoords/Marker12,
	$Container/FoodCoords/Marker13, $Container/FoodCoords/Marker14, $Container/FoodCoords/Marker15
]

@onready var veichle_paths = [
	$Paths/Path01
]
#@onready var veichle_paths = [ $Paths/Path10 ]

func _ready():
	print("ready")
	#$Camera3D.set_current(true)
	
	#$BG.play()
	#$BG.volume_db = -10.0
	
	#for i in 2:
		#var red_sedan = Sedan.instantiate()
		#cars_to_add.push_back(red_sedan)
		#
	for n in Veichle_Total_Count:
		var index = randi_range(0, Veichle_Models.size() - 1)
		var model = Veichle_Models[index]
		cars_to_add.push_back(model.instantiate())
	print(cars_to_add)
	path_dispatcher = PathDispatcher.new()
	path_dispatcher.init(veichle_paths, cars_to_add, Veichle_Speed)
	add_child(path_dispatcher)
	
	#var red_sedan = Sedan.instantiate()

	#$Paths/Path01/PathFollow3D2.progress = 5
	#init_foods()
	
#func init_foods():
	#Fantacy_Food_Model_COORDS.shuffle()
	#for i in Fantacy_Food_Models.size():
		#var food = Fantacy_Food_Models[i].instantiate()
		#add_child(food)
		#food.position = Fantacy_Food_Model_COORDS[i].global_position
		#
	#Normal_Food_Model_COORDS.shuffle()
	#for i in Normal_Food_Models.size():
		#var food = Normal_Food_Models[i].instantiate()
		#add_child(food)
		#food.position = Normal_Food_Model_COORDS[i].global_position

#func _enter_tree():
	#var truck = Truck.instantiate()
	#$Paths/Path01/PathFollow3D.add_child(truck)
	##
	#var suv = SUV.instantiate()
	#$Paths/Path01/PathFollow3D2.add_child(suv)
	
func _process(delta):
	car_move(delta)
	pass

func car_move(delta):
	#for follow in $Paths/Path01.get_children():
		#follow.progress += delta * Veichle_Speed
	#for path in $Paths.get_children():
		#for follow in path.get_children():
			#follow.progress += delta * Veichle_Speed
	pass

func _on_bg_finished():
	$BG.play()

func _on_seagull_completed():
	print("Congra")
	get_tree().change_scene_to_file("res://scences/general/completed.tscn")
	pass # Replace with function body.

func _on_seagull_dead():
	print('dead')
	#get_tree().change_scene_to_file("res://scences/general/gameover.tscn")
	get_tree().change_scene_to_file.bind("res://scences/general/gameover.tscn").call_deferred()
	pass # Replace with function body.

func _on_seagull_timeout():
	print('TIMEOUT')
	get_tree().change_scene_to_file.bind("res://scences/general/gameover.tscn").call_deferred()
	pass # Replace with function body.
