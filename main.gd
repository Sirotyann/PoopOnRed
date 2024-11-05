extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var locale = OS.get_locale().to_lower()
	
	if locale.contains("zh"):
		TranslationServer.set_locale("zh")
	else:
		TranslationServer.set_locale("en")
	
	#Storage.instance.clear_status()
