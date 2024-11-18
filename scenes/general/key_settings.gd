extends Control

@onready var setting_button_scene = preload("res://scenes/buttons/setting_button.tscn")
@onready var action_list = $PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/ActionList
@onready var reset_button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ResetButton
@onready var done_button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/DoneButton

signal close

var is_remapping = false
var action_to_remap = null
var remapping_button = null  

const available_actions = [ "up", "down", "left", "right", "shoot" ]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_action_list()
	reset_button.text = tr("ResetDefault")
	done_button.text = tr("Done")

func create_action_list():
	#InputMap.load_from_project_settings()
	
	for item in action_list.get_children():
		item.queue_free()
	
	for action in available_actions:
		var button = setting_button_scene.instantiate()
		var action_label = button.find_child("LabelAction")
		var input_label = button.find_child("LabelInput")
		action_label.text = tr(action)
		
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			input_label.text = events[0].as_text().trim_suffix(" (Physical)")
		else:
			input_label.text = ""
		action_list.add_child(button)
		button.connect("pressed", on_input_button_pressed.bind(button, action))
	
func on_input_button_pressed(button, action):
	if !is_remapping:
		is_remapping = true
		action_to_remap = action
		remapping_button = button
		button.find_child("LabelInput").text = tr("PressKey")

func _input(event):
	if is_remapping:
		if (
			event is InputEventKey ||
			(event is InputEventMouseButton && event.pressed)
		):
			# 不要双击
			if event is InputEventMouseButton && event.double_click:
				event.double_click = false
			
			InputMap.action_erase_events(action_to_remap)
			InputMap.action_add_event(action_to_remap, event)
			update_action_list(remapping_button, event)
			
			is_remapping = false
			action_to_remap = null
			remapping_button = null
			
			accept_event()
			
func update_action_list(button, event):
	button.find_child("LabelInput").text = event.as_text().trim_suffix(" (Physical)")
	#InputMap

func _on_rest_button_pressed() -> void:
	InputMap.load_from_project_settings()
	create_action_list()

func _on_done_button_pressed() -> void:
	close.emit()
