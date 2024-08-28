extends Node2D

var time_left := 3 * 60

# Called when the node enters the scene tree for the first time.
func _ready():
	display_time()
	#$Timer.start()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func num_to_string(num):
	if num < 10:
		return '0{n}'.format({'n': num})
	return '%s' % num

func display_time():
	var min = floor(time_left / 60)
	var sec = time_left % 60
	print(sec)
	$Label.text = '{min}:{sec}'.format({'min': num_to_string(min), 'sec': num_to_string(sec)})

func _on_timer_timeout():
	time_left -= 1
	display_time()
	pass # Replace with function body.
