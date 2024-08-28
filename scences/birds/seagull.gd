extends CharacterBody3D

signal point_increase

var Poop = preload("res://scences/birds/poop.tscn")

const SPEED := 0.0 #4.5
const JUMP_VELOCITY := 4.5
const TURN_SPEED := 1.2
const CLIMB_SPEED := 0.3
const DIVE_SPEED := 1.2

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var can_excrete = true

var is_hover = false

func _ready():
	$AnimationPlayer.play('fly')
	$CanvasLayer/TimeLeft.connect("time_out", self.time_out)

func _process(delta):
	if Input.is_action_pressed("shoot"):
		shoot()
	
	# 是不是撞了
	for index in get_slide_collision_count():
		var collision = get_slide_collision(index)
		var collider = collision.get_collider()
		
		if collider.is_in_group('moutain') or (collider.get_collision_layer and collider.get_collision_layer() == 1):
			game_over()
			
	# 切换视角
	if Input.is_action_just_pressed("SwitchCamera"):
		$Camera2.set_current(true)
	elif Input.is_action_just_released("SwitchCamera"):
		$Camera1.set_current(true)
		#print($Camera1.current)	

func _physics_process(delta):
	# Add the gravity.
	#if not is_on_floor():
		#velocity.y -= gravity * delta
	
	var speed := 0.0 if is_hover else SPEED
	
	if Input.is_action_just_pressed("hover"):
		is_hover = !is_hover
	#if Input.is_action_pressed("speed_up"):
		#speed = SPEED
	#else:
		#speed = 0	
		
	if Input.is_action_pressed("left"):
		turn_left(delta)
	elif Input.is_action_pressed("right"):
		turn_right(delta)
	else:
		recover_guesture(delta)
		
	if Input.is_action_pressed("up"):
		climb(delta)
	elif Input.is_action_pressed("down"):
		dive(delta)
	else:
		recover_horizontal(delta)
	
	var rotations = get_rotation_degrees()
	var rotation_x = rotations[0]
	var rotation_y = rotations[1]
	var rotation_z = rotations[2]
	
	velocity.z = -cos(deg_to_rad(rotation_y)) * speed
	velocity.x = -sin(deg_to_rad(rotation_y)) * speed
	velocity.y = sin(deg_to_rad(rotation_x)) * speed
	move_and_slide()
	
func rotate_body(x, y, z):
	rotation.x = x
	rotation.y = y
	rotation.z = z
	
# --- Charactor movemet ---	
func dive(delta):
	if rotation.x > -1.0:
		rotate_body(rotation.x - delta * DIVE_SPEED, rotation.y, rotation.z)

func climb(delta):
	if rotation.x < 0.75:
		rotate_body(rotation.x + delta * CLIMB_SPEED, rotation.y, rotation.z)

func recover_horizontal(delta):
	var offset = delta * TURN_SPEED
	if rotation.x <= offset and rotation.x >= -1 * offset:
		rotate_body(0, rotation.y, rotation.z)
	elif rotation.x < 0:
		rotate_body(rotation.x + offset, rotation.y, rotation.z)
	else:
		rotate_body(rotation.x - offset, rotation.y, rotation.z)

func turn_left(delta):
	if rotation.z < 0.75:
		rotate_body(rotation.x, rotation.y + delta * TURN_SPEED, rotation.z + delta * TURN_SPEED)

func turn_right(delta):
	if rotation.z > -0.75:
		rotate_body(rotation.x, rotation.y - delta * TURN_SPEED, rotation.z - delta * TURN_SPEED)
		
func recover_guesture(delta):
	var offset = delta * TURN_SPEED
	if rotation.z <= offset and rotation.z >= -1 * offset:
		rotate_body(rotation.x, rotation.y, 0)
	elif rotation.z < 0:
		rotate_body(rotation.x, rotation.y, rotation.z + offset)
	else:
		rotate_body(rotation.x, rotation.y, rotation.z - offset)

# --- excrete ---
func shoot():
	if can_excrete:
		print('shoot!')
		var poo: RigidBody3D = Poop.instantiate()
		var self_position = get_global_position()
		#poo.position = Vector3(self_position[0], self_position[1] - 0.2, self_position[2])
		poo.position = Vector3(self_position[0], self_position[1], self_position[2])
		poo.rotation = self.rotation
		#poo.transform.scale
		poo.linear_velocity = self.velocity
		can_excrete = false
		poo.connect("collide_with_vehicle", self.add_point)
		poo.connect("collide_with_white_vehicle", self.shoot_target)
		get_tree().root.add_child(poo)
		var timer = Timer.new()
		timer.one_shot = true
		timer.wait_time = 1
		timer.timeout.connect(refresh_excrete)
		add_child(timer)
		timer.start();

func add_point():
	print('Poop on Car!!')

func shoot_target():
	point += 9

func refresh_excrete():
	can_excrete = true


# --- status --- 
func game_over():
	print("Dead!")
	get_tree().paused = true
	
func time_out():
	print('time out')
	game_over()
