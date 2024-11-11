#class_name PathDispatcher

extends Node3D

const ITEM_MIN_DISTANCE := 15.0

var paths = []
var paths_offset = []
var paths_capacity = []
var paths_total_capacity = 0.0
var paths_length = []
var paths_total_length := 0.0
var paths_car_volumn = []

var cloned_paths = []
var items = []
var speed := 0.0

var path_item_map = {}
var item_path_follow_map = {}

func init(_paths, _items, _speed):
	paths = _paths
	items = _items
	items.shuffle()
	speed = _speed
	
	for p in paths:
		var length = p.curve.get_baked_length()
		var capacity = floor(length/ITEM_MIN_DISTANCE)
		paths_capacity.push_back(capacity)
		paths_total_capacity += capacity
		paths_length.push_back(length)
		paths_total_length += length
		paths_offset.push_back(10.0)
		#print("Path {i} capacity {val}".format({"i": paths_length.size() - 1, "val": capacity}))
	
	for capacity_index in range(paths_capacity.size()):
		var capacity = paths_capacity[capacity_index]
		paths_car_volumn.push_back(round(capacity * items.size() / paths_total_capacity))
	
	#print("paths_car_volumn", paths_car_volumn)
	print("paths_capacity", paths_capacity)
	
	var index := 0
	var path_car := 0
	var current_path_index := 0
	for it in items:
		if index > paths_total_capacity: break
		
		var _path = paths[current_path_index]
		it.gravity_scale = 0
		add_item_to_path(it, current_path_index)		
		
		if path_car >= paths_car_volumn[current_path_index] or path_car >= paths_capacity[current_path_index]: 
			path_car = 0
			current_path_index = min(current_path_index + 1, paths.size() - 1) 
		path_car += 1
		index += 1
		#print("add car to path {index}".format({ "index": current_path_index }))
	
	#print("total_capacity: {total}  cars: {cars}".format({"total": paths_total_capacity, "cars": items.size()}))


func add_item_to_path(item, path_index):
	var path = paths[path_index]
	var follow = get_item_path_follow(item)
	follow.progress = paths_offset[path_index]
	paths_offset[path_index] += ITEM_MIN_DISTANCE
	path.add_child(follow)
	
func get_item_path_follow(item):
	var item_id = item.get_instance_id()
	if(!item_path_follow_map.has(item_id)):
		var follow = PathFollow3D.new()
		follow.use_model_front = true
		follow.cubic_interp = true
		follow.loop = true
		follow.tilt_enabled = false
		follow.add_child(item)
		item.rotation = Vector3(0, 0, 0)
		item.position = Vector3(0, 0, 0)
		item_path_follow_map[item_id] = follow
		
	return item_path_follow_map.get(item_id)

func _process(delta):
	for path in paths:
		var path_follows = path.get_children()		
		for follow in path_follows:
			follow.progress += delta * speed
