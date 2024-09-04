class_name Food extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready():
	print('FOod init')
	self.connect('body_entered', _on_body_entered)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	print("BODY ENTERED", body)
	if body.has_method("hit_food"):
		body.hit_food(self)
	pass # Replace with function body.

func init():
	self.connect('body_entered', _on_body_entered)
