extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	#$BuildingMap.get_child(0).connect("")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_building_map_child_entered_tree(node):
	print('build collision')
	pass # Replace with function body.
