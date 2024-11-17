extends Node
class_name Sequence

signal completed
signal dead

func connect_player(player):
	#print("MaxLife : ", Settings.MaxLife)
	player.connect('completed', self.game_win)
	player.connect('dead', self.game_dead.bind(player))
	player.connect('timeout', self.game_dead.bind(player))

func game_win():
	var tree = get_tree()
	tree.paused = true
	completed.emit()	
	await tree.create_timer(4.0).timeout
	
	if General.mode == 'practice':
		tree.change_scene_to_file("res://scenes/general/completed.tscn")
	else:
		var scene = Storage.instance.get_var("playing_map")
		Storage.instance.complete_scene(scene)
		if General.is_last_map(scene):
			Storage.instance.complete_game()
			tree.change_scene_to_file("res://scenes/general/completed.tscn")
		else:
			var next = General.get_next_map(scene)
			Storage.instance.set_var("playing_map", next)
			tree.change_scene_to_file("res://scenes/general/life.tscn")
	tree.paused = false

func game_dead(player):
	player.play_death_animation()
	var tree = get_tree()
	dead.emit()
	tree.paused = true
	await tree.create_timer(3.0).timeout
	if General.mode == 'practice':
		tree.change_scene_to_file("res://scenes/general/gameover.tscn")
	else:
		var life = Storage.instance.get_var("life")
		if life <= 1:
			Storage.instance.reset_play()			
			tree.change_scene_to_file("res://scenes/general/gameover.tscn")
		else:
			Storage.instance.life_lost()
			tree.change_scene_to_file("res://scenes/general/life.tscn")
	tree.paused = false

func game_timeout():
	var tree = get_tree()
	tree.paused = true
	dead.emit()
	await tree.create_timer(3.0).timeout
	tree.change_scene_to_file("res://scenes/general/gameover.tscn")
	tree.paused = false
