#class_name PathDispatcher

extends Node3D

var paths = []
var paths_offset = []
var cloned_paths = []
var items = []
var speed := 0.0

var item_path_follow_map = {}

func init(_paths, _items, _speed):
	paths = _paths
	items = _items
	speed = _speed
	
	for p in paths:
		paths_offset.push_back(0.0)
	
	for it in items:
		random_pick_path(it)

func add_item(item):
	items.push_back(item)
	random_pick_path(item)

func random_pick_path(item):
	var index = randi_range(0, paths.size() - 1)
	var path = paths[index]
	#var cloned_path = path.duplicate()
	#path.get_parent().add_child(cloned_path)
	#cloned_paths.push_back(cloned_path)
	var follow = get_item_path_follow(item)
	follow.progress = paths_offset[index]
	paths_offset[index] += 5.0
	path.add_child(follow)
	#follow.set_progress_ratio(0.89)
	#cloned_path.add_child(follow)
	
func get_item_path_follow(item):
	var item_id = item.get_instance_id()
	if(!item_path_follow_map.has(item_id)):
		var follow = PathFollow3D.new()
		follow.use_model_front = true
		follow.add_child(item)
		item_path_follow_map[item_id] = follow
		
	return item_path_follow_map.get(item_id)
	
func path_follow_complete(path, path_follow):
	print('!! path_follow_complete !!')
	path.remove_child(path_follow)
	path_follow.progress = 0.0
	var items = path_follow.get_children()
	for it in items:
		random_pick_path(it)

func _process(delta):
	for path in paths:
		var path_follows = path.get_children()
		for follow in path_follows:
			follow.progress += delta * speed
			#print(follow.progress_ratio)
			#if follow.progress_ratio > 0.99: path_follow_complete(path, follow)



