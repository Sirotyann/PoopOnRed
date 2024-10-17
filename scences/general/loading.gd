extends Node2D

var progress = []
var target_scence = null
var scene_load_status = 0
 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(target_scence)
	if target_scence != null:
		scene_load_status = ResourceLoader.load_threaded_get_status(target_scence, progress)
		update_progress(progress[0])
		if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
			var new_scene = ResourceLoader.load_threaded_get(target_scence)
			get_tree().change_scene_to_packed(new_scene)
			self.queue_free()

func update_progress(val):
	$Percentage.text = "{progress}%".format({"progress": val * 100})

func switch_scence(path):
	print('switch_scence to ', path)
	target_scence = path
	ResourceLoader.load_threaded_request(target_scence)
