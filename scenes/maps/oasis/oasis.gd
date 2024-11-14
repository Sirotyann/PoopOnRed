extends Node3D

const Veichle_Speed := 6.6
const Veichle_Total_Count := 80 # total_capacity: 102 
const Red_Car_count := 1

var PathDispatcher = preload("res://general/path_dispatcher.gd")

var Sequence = preload("res://scenes/general/sequence.gd")
@onready var sequence = Sequence.new()

# Vehicles
const Delivery = preload("res://scenes/kit/cars/delivery.tscn")
const SUVWhite = preload("res://scenes/kit/cars/suv_white.tscn")
const SUVGreen = preload("res://scenes/kit/cars/suv-green.tscn")
const SuvBlack = preload("res://scenes/kit/cars/suv-black.tscn")
const SuvBlue = preload("res://scenes/kit/cars/suv-blue.tscn")
const Sedan = preload("res://scenes/kit/cars/sedan-sports.tscn")
const SedanBlue = preload("res://scenes/kit/cars/sedan-blue.tscn")
const SedanGreen = preload("res://scenes/kit/cars/sedan-green.tscn")
const SUV = preload("res://scenes/kit/cars/suv_luxury.tscn")
const Texi = preload("res://scenes/kit/cars/taxi.tscn")
const Truck = preload("res://scenes/kit/cars/truck.tscn")
const Van = preload("res://scenes/kit/cars/van.tscn")

# Food
const Cake = preload("res://scenes/kit/food/cake.tscn")
const Apple = preload("res://scenes/kit/food/apple.tscn")
const Burger = preload("res://scenes/kit/food/burger.tscn")
const Coissant = preload("res://scenes/kit/food/croissant.tscn")
const Donut = preload("res://scenes/kit/food/donut.tscn")
const Fires = preload("res://scenes/kit/food/fries.tscn")
const Hotdog = preload("res://scenes/kit/food/hot_dog.tscn")
const Pizza = preload("res://scenes/kit/food/pizza.tscn")
const Taco = preload("res://scenes/kit/food/taco.tscn")

var passed_time := 0
var timer
var path_dispatcher
var cars_to_add = []

@onready var Veichle_Models = [Delivery, SUV, Texi, Truck, Van, SUVWhite, SedanBlue, SedanGreen, SUVGreen, SuvBlack, SuvBlue]
@onready var Fantacy_Food_Models = [Cake, Burger, Pizza]
@onready var Fantacy_Food_Model_COORDS = [$Container/FoodCoords/Marker01, $Container/FoodCoords/Marker02, $Container/FoodCoords/Marker03]
@onready var Normal_Food_Models = [Apple, Coissant, Donut, Fires, Hotdog, Taco, Fires, Pizza]
@onready var Normal_Food_Model_COORDS = [
	$Container/FoodCoords/Marker04, $Container/FoodCoords/Marker05, $Container/FoodCoords/Marker06, 
	$Container/FoodCoords/Marker07, $Container/FoodCoords/Marker08
]

@onready var veichle_paths = [ $Paths/Path01, $Paths/Path02 ]

func _ready():
	$WorldEnvironment.environment.fog_enabled = true
	$BG.play()
	$BG.volume_db = -10.0
	
	$seagull.SPEED = 5.6
	
	for i in Red_Car_count:
		var red_sedan = Sedan.instantiate()
		cars_to_add.push_back(red_sedan)
	
	for n in Veichle_Total_Count:
		var index = randi_range(0, Veichle_Models.size() - 1)
		var model = Veichle_Models[index]
		cars_to_add.push_back(model.instantiate())
	path_dispatcher = PathDispatcher.new()
	path_dispatcher.init(veichle_paths, cars_to_add, Veichle_Speed)
	add_child(path_dispatcher)
	init_foods()
	
	add_child(sequence)
	sequence.connect_player($seagull)
	
	$RandomWind.start()
	#RandomWind.instance.start()
	#RandomWind.instance.connect('wind_change', self.apply_wind)
	#add_child(RandomWind.instance)
	
func init_foods():
	Fantacy_Food_Model_COORDS.shuffle()
	for i in min(Fantacy_Food_Models.size(), Fantacy_Food_Model_COORDS.size()):
		var food = Fantacy_Food_Models[i].instantiate()
		add_child(food)
		food.position = Fantacy_Food_Model_COORDS[i].global_position
		
	Normal_Food_Model_COORDS.shuffle()
	for i in min(Normal_Food_Models.size(), Normal_Food_Model_COORDS.size()):
		var food = Normal_Food_Models[i].instantiate()
		add_child(food)
		food.position = Normal_Food_Model_COORDS[i].global_position

func _on_bg_finished():
	$BG.play()

func apply_wind():
	print('！！！！！！ Apply Wind')
	var wind = $RandomWind.get_wind()
	print(wind)
	if(wind == Vector3(0.0,0.0,0.0)):
		print("### No wind")
		$WindAudio.stop()
	else:
		$WindAudio.play()
	$seagull.wind_offset = wind
