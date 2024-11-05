extends RigidBody3D

signal collide_with_vehicle
signal collide_with_white_vehicle

var triggerd := false

func _on_body_entered(body):
	body.get_groups()
	
	if body.is_in_group("vehicle"):
		collide_with_vehicle.emit()
			
		if body.is_in_group("red"):
			collide_with_white_vehicle.emit()
			
	self.queue_free()

func give_force(direction):
	apply_central_impulse(direction)
