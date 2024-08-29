extends Node2D

var time_left := 3 * 60
var warning_time := 20
var safe_time := 60

var safe_color := Color(0.3, 0.80, 0.32, 1.0)
var warning_color := Color(0.92, 0.47, 0.18, 1.0)
var danger_color := Color(0.80, 0.0, 0.0, 1.0)

signal time_out

# Called when the node enters the scene tree for the first time.
func _ready():
	display_time()
	$Label.set("theme_override_colors/font_color", safe_color)
	$Timer.start()

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
	$Label.text = '{min}:{sec}'.format({'min': num_to_string(min), 'sec': num_to_string(sec)})
	$Label.set("theme_override_colors/font_color", safe_color)

func _on_timer_timeout():
	if time_left > 0:
		time_left -= 1
		display_time()
		if time_left <= warning_time:
			$Label.set("theme_override_colors/font_color", danger_color)
		elif time_left <= safe_time:
			$Label.set("theme_override_colors/font_color", warning_color)
		else:
			$Label.set("theme_override_colors/font_color", safe_color)
	else:
		time_out.emit()
		$Timer.stop()

func increase_time(val):
	time_left += val

func deduct_time(val):
	var result = time_left - val
	if result >=0:
		time_left = 0
	else:
		time_left = result
