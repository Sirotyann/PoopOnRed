extends Node

class_name General

static var is_dev := false # true

static var mode := "practice" #  play 挑战模式 还是 练习模式 practice

static var current_map := ""

static var map_queue := ["firstshot", "town", "valley", "village", "oasis"]

static var MapScenePath := {
	"firstshot": "res://scenes/maps/practice/practice.tscn", 
	"town": "res://scenes/maps/town/town.tscn",
	"valley": "res://scenes/maps/fog_valley/fog_valley.tscn", 
	"village":"res://scenes/maps/three_villages/three_villages.tscn",
	"oasis": "res://scenes/maps/oasis/oasis.tscn"
}	

static func is_last_map(current):
	return current == map_queue[map_queue.size() - 1]

static func get_next_map(current):
	var index = map_queue.find(current)
	if index < 4:
		return map_queue[index + 1]
	else:
		return map_queue[0]
