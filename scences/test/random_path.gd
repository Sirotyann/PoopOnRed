extends Node3D

var PathDispatcher = preload("res://general/path_dispatcher.gd")
var suv = preload("res://scences/kit/cars/suv_white.tscn")
var sedan = preload("res://scences/kit/cars/sedan-sports.tscn")
var delivery = preload("res://scences/kit/cars/delivery.tscn")


@onready var paths = [$Path3D, $Path3D2, $Path3D3]

var follows = []

var current_path_follow = null

var suv_0 = null

# Called when the node enters the scene tree for the first time.
func _ready():
	suv_0 = suv.instantiate()
	var sedan_0 = sedan.instantiate()
	var sedan_1 = sedan.instantiate()
	#follow_random_path(suv_0, paths)
	var path_dispather = PathDispatcher.new()
	
	#add_child(suv_0)
	add_child(path_dispather)
	
	path_dispather.init(paths, [suv_0, sedan_0, sedan_1], 3.5)
	
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
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#var speed = 3.5
	#if current_path_follow != null:
		#current_path_follow.progress += delta * speed
		#
		#if current_path_follow.progress_ratio > 0.99:
			#print('!! complete move')
			#remove_children(current_path_follow)
			#follow_random_path(suv_0, paths)
