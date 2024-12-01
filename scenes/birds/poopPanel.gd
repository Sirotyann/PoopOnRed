extends Node2D

#var is_practice
var MAX_COUNT = Config.get_max_poop()
var count = MAX_COUNT
#const MAX_COUNT := 3
var poops = []

# Called when the node enters the scene tree for the first time.
func _ready():
	poops = [$poop0, $poop1, $poop2, $poop3, $poop4, $poop5]
	refresh_status()

func add(num):
	if count < MAX_COUNT:
		count = min(MAX_COUNT, count + num)
		refresh_status()
		$AnimationPlayer.play('glow')
	
func minus(num):
	count = max(0, count - num)
	refresh_status()
	$AnimationPlayer.play('glow')
	
func refresh_status():
	for i in poops.size():
		poops[i].visible = (i < count)
