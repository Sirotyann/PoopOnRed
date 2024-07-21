extends CharacterBody3D

var Guano = preload("res://scences/birds/guano.tscn")

const SPEED = 7.5
const JUMP_VELOCITY = 4.5
const TURN_SPEED = 0.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var can_excrete = true

func _ready():
	$AnimationPlayer.play('fly')

func _process(delta):
	if Input.is_action_pressed("shoot"):
		shoot()

func _physics_process(delta):
	# Add the gravity.
	#if not is_on_floor():
		#velocity.y -= gravity * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
		
	if Input.is_action_pressed("ui_left"):
		turn_left(delta)
	elif Input.is_action_pressed("ui_right"):
		turn_right(delta)
	else:
		recover_guesture(delta)
		
	if Input.is_action_pressed("ui_up"):
		climb(delta)
	elif Input.is_action_pressed("ui_down"):
		dive(delta)
	else:
		recover_horizontal(delta)
	
	var rotations = get_rotation_degrees()
	var rotation_x = rotations[0]
	var rotation_y = rotations[1]
	var rotation_z = rotations[2]
	
	velocity.z = -cos(deg_to_rad(rotation_y)) * SPEED
	velocity.x = -sin(deg_to_rad(rotation_y)) * SPEED
	velocity.y = sin(deg_to_rad(rotation_x)) * SPEED
	move_and_slide()

# --- Charactor movemet ---	
func dive(delta):
	if rotation.x > -1.0:
		rotation.x = rotation.x - delta * TURN_SPEED

func climb(delta):
	if rotation.x < 0.75:
		rotation.x = rotation.x + delta * TURN_SPEED

func recover_horizontal(delta):
	var offset = delta * TURN_SPEED
	if rotation.x <= offset and rotation.x >= -1 * offset:
		rotation.x = 0
	elif rotation.x < 0:
		rotation.x = rotation.x + offset
	else:
		rotation.x = rotation.x - offset

func turn_left(delta):
	rotation.y = rotation.y + delta * TURN_SPEED
	if rotation.z < 0.75:
		rotation.z = rotation.z + delta * TURN_SPEED

func turn_right(delta):
	rotation.y = rotation.y - delta * TURN_SPEED
	if rotation.z > -0.75:
		rotation.z = rotation.z - delta * TURN_SPEED
		
func recover_guesture(delta):
	var offset = delta * TURN_SPEED
	if rotation.z <= offset and rotation.z >= -1 * offset:
		rotation.z = 0
	elif rotation.z < 0:
		rotation.z = rotation.z + offset
	else:
		rotation.z = rotation.z - offset

# --- excrete ---
func shoot():
	if can_excrete:
		print("shoot")
		var guano: RigidBody3D = Guano.instantiate()
		var self_position = get_global_position()
		guano.position = Vector3(self_position[0], self_position[1] - 0.2, self_position[2])
		guano.rotation = self.rotation
		guano.linear_velocity = self.velocity
		can_excrete = false
		get_parent().add_child(guano)
		var timer = Timer.new()
		timer.one_shot = true
		timer.wait_time = 1
		timer.timeout.connect(refresh_excrete)
		add_child(timer)
		timer.start();

func refresh_excrete():
	can_excrete = true
