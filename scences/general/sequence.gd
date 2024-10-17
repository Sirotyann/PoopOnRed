extends Node

func connect_player(player):
	player.connect('completed', self.game_win.bind(player))
	player.connect('dead', self.game_dead.bind(player))
	player.connect('timeout', self.game_dead.bind(player))

func game_win(player):
	var tree = get_tree()
	tree.paused = true
	await tree.create_timer(3.0).timeout
	tree.change_scene_to_file("res://scences/general/completed.tscn")
	tree.paused = false

func game_dead(player):
	player.play_death_particle()
	var tree = get_tree()
	tree.paused = true
	await tree.create_timer(1.0).timeout
	tree.change_scene_to_file("res://scences/general/gameover.tscn")
	tree.paused = false

func game_timeout(player):
	var tree = get_tree()
	tree.paused = true
	await tree.create_timer(3.0).timeout
	tree.change_scene_to_file("res://scences/general/gameover.tscn")
	tree.paused = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
