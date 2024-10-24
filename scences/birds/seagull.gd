extends CharacterBody3D

signal completed
signal dead
signal timeout

var score := 0

var Poop = preload("res://scences/birds/poop.tscn")
var StorageCLS = preload("res://general/storage.gd")

@onready var Storage = StorageCLS.new()
@onready var StatusAnimation = $CanvasLayer/CanvasAnimationPlayer

const VEHICLE_TIME_AWARD := 15.0 # 每次命中普通车的时间奖励

const MAX_FLY_HEIGHT := 35.0 # 能飞的最大高度
const WIND_SOUND_Y_MIN := 0.0 # play sound while reach hight
const WIND_SOUND_Y_MAX := 25.0 # play sound while reach hight
const WIND_SOUND_MIN := -80.0
const WIND_SOUND_MAX := 0.0 

const SPEED := 4.5
const TURN_SPEED := 1.25
const CLIMB_SPEED := 0.3
const DIVE_SPEED := 1.25

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") * 0.7
var default_gravity_speed = gravity
var dive_speed_offset := 0.0 # dive 以后的速度加成

var can_excrete = true

var is_hover = false

var is_debug = false

var should_rotate_camera := true

func _ready():
	$CanvasLayer/HBoxContainer/TimeLeft.connect("time_out", self.time_out)
	$CanvasLayer/HBoxContainer/TimeLeft.connect("danger_warning", self.danger_warning)
	$CanvasLayer/HBoxContainer/TimeLeft.connect("danger_warning_cancel", self.danger_warning_cancel)
	
	var is_first_time = Storage.get_is_first_time()
	print(is_first_time)
		
func _process(delta):
	if Input.is_action_pressed("shoot"):
		shoot()
	
	# 是不是撞了
	for index in get_slide_collision_count():
		var collision = get_slide_collision(index)
		var collider = collision.get_collider()
		if collider.is_in_group('food'):
			hit_food(collider)
		
		if collider.get_collision_layer: print(collider.get_collision_layer())
		
		if collider.is_in_group('moutain') or collider.is_in_group('vehicle') or (collider.get_collision_layer and collider.get_collision_layer() == 1):
			game_over()
			
	# 切换视角
	if Input.is_action_just_pressed("SwitchCamera"):
		$Camera2.set_current(true)
	elif Input.is_action_just_released("SwitchCamera"):
		$Camera1.set_current(true)

	# 是否旋转 Camera, Temproray
	if Input.is_action_just_pressed("ToggleRotatiobMode"):
		should_rotate_camera = !should_rotate_camera

func _physics_process(delta):
	var speed := 0.0 if is_hover else SPEED
	var gravity_speed = 0.0 if is_hover else (default_gravity_speed / 10)
	
	if !$Sprite/AnimationPlayer.is_playing():
		$Sprite/AnimationPlayer.play('fly')
	
	if Input.is_action_just_pressed("hover"):
		is_hover = !is_hover
		
	var fly_speed := 1.0
	
	if Input.is_action_pressed("left"):
		turn_left(delta)
		fly_speed = 1.5
	elif Input.is_action_pressed("right"):
		turn_right(delta)
		fly_speed = 1.5
	else:
		recover_guesture(delta)
		
	if Input.is_action_pressed("up"):
		fly_speed = 2.0
		climb(delta)
		gravity_speed = gravity_speed / 2
		if dive_speed_offset > 0:
			dive_speed_offset -= delta
			speed += dive_speed_offset
		else:
			dive_speed_offset = 0.0
		
	elif Input.is_action_pressed("down"):
		dive(delta)
		$Sprite/AnimationPlayer.stop()
		gravity_speed = gravity_speed * 1.2
		dive_speed_offset = -velocity.y
	else:
		recover_horizontal(delta)
		if dive_speed_offset > 0:
			dive_speed_offset -= delta
			speed += dive_speed_offset
		else:
			dive_speed_offset = 0.0
	
	$Sprite/AnimationPlayer.speed_scale = fly_speed
	
			
	var rotations = get_rotation_degrees()
	var rotation_x = rotations[0]
	var rotation_y = rotations[1]
	var rotation_z = rotations[2]
	
	velocity.z = -cos(deg_to_rad(rotation_y)) * speed
	velocity.x = -sin(deg_to_rad(rotation_y)) * speed
	
	if position.y < MAX_FLY_HEIGHT:
		velocity.y = sin(deg_to_rad(rotation_x)) * speed
	else:
		velocity.y = 0.0

	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity_speed
		
	move_and_slide()
	play_wind_audio()
	
func rotate_body(x, y, z):
	rotation.x = x
	rotation.y = y
	if  should_rotate_camera:
		rotation.z = z
	else:
		$Sprite.rotation.z = z
	
func get_the_rotation():
	var z = rotation.z if should_rotate_camera else $Sprite.rotation.z
	return Vector3(rotation.x, rotation.y, z)
	
# --- Charactor movemet ---	
func dive(delta):
	var the_rotation = get_the_rotation()
	if the_rotation.x > -1.0:
		rotate_body(the_rotation.x - delta * DIVE_SPEED, the_rotation.y, the_rotation.z)

func climb(delta):
	var the_rotation = get_the_rotation()
	if the_rotation.x < 0.75:
		rotate_body(the_rotation.x + delta * CLIMB_SPEED, the_rotation.y, the_rotation.z)

func recover_horizontal(delta):
	var the_rotation = get_the_rotation()
	var offset = delta * TURN_SPEED
	if the_rotation.x <= offset and the_rotation.x >= -1 * offset:
		rotate_body(0, the_rotation.y, the_rotation.z)
	elif the_rotation.x < 0:
		rotate_body(the_rotation.x + offset, the_rotation.y, the_rotation.z)
	else:
		rotate_body(the_rotation.x - offset, the_rotation.y, the_rotation.z)

func turn_left(delta):
	var the_rotation = get_the_rotation()
	var _y = the_rotation.y + delta * TURN_SPEED
	var _z = the_rotation.z + delta * TURN_SPEED
	if the_rotation.z < 0.75:
		rotate_body(the_rotation.x, _y, _z)
	else:
		rotate_body(the_rotation.x, _y, the_rotation.z)

func turn_right(delta):
	var the_rotation = get_the_rotation()
	var _y = the_rotation.y - delta * TURN_SPEED
	var _z = the_rotation.z - delta * TURN_SPEED
	if the_rotation.z > -0.75:
		rotate_body(the_rotation.x, _y, _z)
	else:
		rotate_body(the_rotation.x, _y, the_rotation.z)
		
func recover_guesture(delta):
	var offset = delta * TURN_SPEED
	var the_rotation = get_the_rotation()
	if the_rotation.z <= offset and the_rotation.z >= -1 * offset:
		rotate_body(the_rotation.x, the_rotation.y, 0)
	elif the_rotation.z < 0:
		rotate_body(the_rotation.x, the_rotation.y, the_rotation.z + offset)
	else:
		rotate_body(the_rotation.x, the_rotation.y, the_rotation.z - offset)

# --- excrete ---
func shoot():
	if can_excrete and $CanvasLayer/HBoxContainer/PoopPanel.count > 0:
		var poo: RigidBody3D = Poop.instantiate()
		poo.rotation = self.rotation
		poo.give_force(self.velocity)
		$CanvasLayer/HBoxContainer/PoopPanel.minus(1)
		
		$PoopAudio.play()
		
		can_excrete = false
		poo.connect("collide_with_vehicle", self.poop_on_vehicle)
		poo.connect("collide_with_white_vehicle", self.poop_on_red_vehicle)
		get_tree().root.add_child(poo)
		poo.global_position = $Sprite/Marker3D.global_position
		var timer = Timer.new()
		timer.one_shot = true
		timer.wait_time = 1
		timer.timeout.connect(refresh_excrete)
		add_child(timer)
		timer.start();
		

func poop_on_vehicle():
	$CanvasLayer/HBoxContainer/TimeLeft.increase_time(VEHICLE_TIME_AWARD)
	$SuccessAudio.play()

func poop_on_red_vehicle():
	completed.emit()

func refresh_excrete():
	can_excrete = true
	
# --- eat food ---
func hit_food(food):
	$CanvasLayer/HBoxContainer/PoopPanel.add(food.poop_value)
	food.queue_free()

# --- effects --- 
func play_death_particle():
	StatusAnimation.play("death")
	
func time_out(): 
	StatusAnimation.play("death")
	timeout.emit()

func game_over():
	StatusAnimation.play("death")
	dead.emit()

func danger_warning():
	StatusAnimation.play("damage") 

func danger_warning_cancel():
	StatusAnimation.stop()

# --- sound ---
func play_wind_audio():
	if position.y < WIND_SOUND_Y_MIN and $WindAudio.playing:
		$WindAudio.stop()
	elif position.y >= WIND_SOUND_Y_MAX:
		$WindAudio.volume_db = WIND_SOUND_MAX
		if !$WindAudio.playing: 
			$WindAudio.play()
	else:
		$WindAudio.volume_db = WIND_SOUND_MIN - WIND_SOUND_MIN * (position.y - WIND_SOUND_Y_MIN) / (WIND_SOUND_Y_MAX - WIND_SOUND_Y_MIN)
		if !$WindAudio.playing: 
			$WindAudio.play()
