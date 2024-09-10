#class_name PathDispatcher

extends Node3D

var paths = []
var paths_offset = []
var cloned_paths = []
var items = []
var speed := 0.0

var path_item_map = {}
var item_path_follow_map = {}

#func init(_paths, _items, _speed):
	#paths = _paths
	#items = _items
	#items.shuffle()
	#speed = _speed
	#
	#var offset := 0.0
	#
	#for p in paths:
		#var follow = PathFollow3D.new()
		#follow.use_model_front = true
		#p.add_child(follow)
		##paths_offset.push_back(0.0)
	#
	#var path_index := 0
	#for it in items:
		#if path_index >= paths.size():
			#path_index = 0
		#var path = paths[path_index]
	

func init(_paths, _items, _speed):
	paths = _paths
	items = _items
	speed = _speed
	
	for p in paths:
		paths_offset.push_back(10.0)
	
	for it in items:
		random_pick_path(it)

func add_item(item):
	items.push_back(item)
	random_pick_path(item)

func random_pick_path(item):
	var index = randi_range(0, paths.size() - 1)
	var path = paths[index]
	var follow = get_item_path_follow(item)
	follow.progress = paths_offset[index]
	paths_offset[index] += 15.0
	path.add_child(follow)
	
func get_item_path_follow(item):
	var item_id = item.get_instance_id()
	if(!item_path_follow_map.has(item_id)):
		var follow = PathFollow3D.new()
		follow.use_model_front = true
		follow.add_child(item)
		item_path_follow_map[item_id] = follow
		
	return item_path_follow_map.get(item_id)

func _process(delta):
	for path in paths:
		var path_follows = path.get_children()		
		for follow in path_follows:
			follow.progress += delta * speed



