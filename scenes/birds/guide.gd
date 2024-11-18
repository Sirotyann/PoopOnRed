extends CanvasLayer

var step := 0

signal over

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TimeIntroContainer/TimeIntro/Label.text = tr('GUID_TIME')
	$PoopIntroContainer/PoopIntro/Label.text = tr('GUID_POOP')
	$PoopIntroContainer/PoopIntro.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		show_next_guide()

func show_next_guide():
	if step == 0:
		$TimeIntroContainer/TimeIntro.visible = false
		$PoopIntroContainer/PoopIntro.visible = true 
		step = 1
	elif step == 1:
		$PoopIntroContainer/PoopIntro.visible = false
		over.emit()
