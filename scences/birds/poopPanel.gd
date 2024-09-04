extends Node2D

var count := 3
const MAX_COUNT := 3
var poops = []

# Called when the node enters the scene tree for the first time.
func _ready():
	poops = [$poop0, $poop1, $poop2]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add(num):
	if count < MAX_COUNT:
		poops[count].visible = true
		count += 1
	
func minus(num):
	count -= 1
	poops[count].visible = false
