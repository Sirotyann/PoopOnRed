extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const TURN_SPEED = 0.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	$AnimationPlayer.play('fly')

func _physics_process(delta):
	# Add the gravity.
	#if not is_on_floor():
		#velocity.y -= gravity * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	##print(input_dir)
	##print('direction', direction)
	#if direction:
		##velocity.x = direction.x * SPEED
		#velocity.z = direction.z * SPEED
	#else:
		##velocity.x = move_toward(velocity.x, 0, SPEED)
		#velocity.z = move_toward(velocity.z, 0, SPEED)
		#
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
	
	#print("rotation.y = %s" % rotation.y)
	var rotations = get_rotation_degrees()
	var rotation_x = rotations[0]
	var rotation_y = rotations[1]
	var rotation_z = rotations[2]
	
	#print(get_rotation_degrees()[1])
	#print("cos 90 = %s" % cos(deg_to_rad(rotation_y)))
	#print(velocity)
	velocity.z = -cos(deg_to_rad(rotation_y)) * SPEED
	velocity.x = -sin(deg_to_rad(rotation_y)) * SPEED
	velocity.y = sin(deg_to_rad(rotation_x)) * SPEED
	move_and_slide()
	
func dive(delta):
	if rotation.x > -1.0:
		rotation.x = rotation.x - delta * TURN_SPEED

func climb(delta):
	if rotation.x < 0.5:
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
