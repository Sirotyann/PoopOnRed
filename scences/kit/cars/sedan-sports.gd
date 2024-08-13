extends VehicleBody3D

signal should_stop
signal should_resume

var hitted_vehicle = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if hitted_vehicle == null and body.is_in_group("vehicle"):
		hitted_vehicle = body
		should_stop.emit()


func _on_body_exited(body):
	if body == hitted_vehicle:
		hitted_vehicle = null
		should_resume.emit()
