extends Node3D

var Storage = preload("res://general/storage.gd")

const Veichle_Speed := 6.8
const Veichle_Total_Count := 20

const Red_Car_count := 3

var PathDispatcher = preload("res://general/path_dispatcher.gd")
var Sequence = preload("res://scenes/general/sequence.gd")


var passed_time := 0
var timer
var path_dispatcher
var cars_to_add = []

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

@onready var sequence = Sequence.new()

@onready var Veichle_Models = [Delivery, SUV, Texi, Truck, Van, SUVWhite, SedanBlue, SedanGreen, SUVGreen, SuvBlack, SuvBlue]

@onready var veichle_paths = [ $Paths/Path01, $Paths/Path02 ]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("get_is_practice_completed: {t}".format({"t": Storage.instance.get_is_practice_completed()}))
	if Storage.instance.get_is_practice_completed():
		play_bg_audio()
	else:
		$seagull.connect("guide_over", play_bg_audio)
	
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
	
	add_child(sequence)
	sequence.connect_player($seagull)
	
	#Storage.instance.set_is_practice_completed(true)

func play_bg_audio():
	$BG.play()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
