extends Node

signal completed

func connect_player(player):
	player.connect('completed', self.game_win)
	player.connect('dead', self.game_dead.bind(player))
	player.connect('timeout', self.game_dead)

func game_win():
	var tree = get_tree()
	tree.paused = true
	completed.emit()
	await tree.create_timer(4.0).timeout
	tree.change_scene_to_file("res://scenes/general/completed.tscn")
	tree.paused = false

func game_dead(player):
	player.play_death_animation()
	var tree = get_tree()
	tree.paused = true
	await tree.create_timer(3.0).timeout
	tree.change_scene_to_file("res://scenes/general/gameover.tscn")
	tree.paused = false

func game_timeout():
	var tree = get_tree()
	tree.paused = true
	await tree.create_timer(3.0).timeout
	tree.change_scene_to_file("res://scenes/general/gameover.tscn")
	tree.paused = false
