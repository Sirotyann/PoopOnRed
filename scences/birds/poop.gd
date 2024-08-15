extends RigidBody3D

signal collide_with_vehicle
signal collide_with_white_vehicle

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	body.get_groups()
	print('poop hit ', body)
	if body.is_in_group("vehicle"):
		collide_with_vehicle.emit()
		
		if body.is_in_group("white"):
			collide_with_white_vehicle.emit()
			
	queue_free()
