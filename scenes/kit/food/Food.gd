class_name Food extends Area3D


@export var poop_value := 1

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect('body_entered', _on_body_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	if body.has_method("hit_food"):
		body.hit_food(self)

func init():
	self.connect('body_entered', _on_body_entered)
