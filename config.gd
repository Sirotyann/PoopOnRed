extends Node

class_name Config

const is_dev := false # false  true
const is_testing := false

const mode := "PC" # MOBILE / PC / Mac
const device := "PC" # iPhone / PC / Mac

const EnoughPracticeCount := 3
const MaxLife := 3

#const Accelerometer = false

static func get_max_poop():
	if General.mode == 'practice':
		return 6
	else:
		return 3
