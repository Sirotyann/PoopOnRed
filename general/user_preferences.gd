extends Resource

class_name UserPreferences

const preferences_path = "user://user_references.tres"

@export var input_map:Dictionary = {}

func save() -> void:
	ResourceSaver.save(self, preferences_path)

static func load_or_create() -> UserPreferences:
	var res: UserPreferences = load(preferences_path) as UserPreferences
	if !res:
		res = UserPreferences.new()
	return res

static func remove() -> void:
	if ResourceLoader.exists(preferences_path):
		DirAccess.remove_absolute(preferences_path)

	
