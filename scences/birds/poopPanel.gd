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
		count = min(3, count + num)
		refresh_status()
		$AnimationPlayer.play('glow')
	
func minus(num):
	count = max(0, count - num)
	refresh_status()
	$AnimationPlayer.play('glow')
	
func refresh_status():
	for i in poops.size():
		poops[i].visible = (i < count)
