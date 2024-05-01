extends CharacterBody3D


# Declaration of variables and constants
var speed
const WALK_SPEED = 8.0
const RUN_SPEED = 16.0
const JUMP_VELOCITY = 12

#Bob Variables
const BOB_FREQ = 2.0
const BOB_AMP = 0.08
var t_bob = 0.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 24 # ProjectSettings.get_setting("physics/3d/default_gravity")
var sensitivity = 0.002
var block: int = 8 #ID of blocks to place


# Exports the InventoryData script as variable
@export var inventory_data: InventoryData

# This signal is sent to determine the state of the toggle
signal toggle_inventory()

# Ready the nodes of the scene as variables
@onready var head = $Head
@onready var camera_3d = $Head/Camera3D
@onready var ray_cast_3d = $Head/Camera3D/RayCast3D
@onready var inventory_ui = $"../UI/InventoryUI"
@onready var place_sound = $Place_Sound
@onready var break_sound = $Break_Sound
@onready var pause_menu = $pause_menu

# preloads the path of scenes/nodes into strings
const HOTBAR_INVENTORY = preload("res://inventory/hotbar_inventory.tscn")
const SLOT = preload("res://inventory/slot.tscn")


# The initial function to be called when script is run
func _ready():
	PlayerManager.player = self
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# This function handles input as unhandled (lowest priority type of input)
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotation.y = rotation.y - event.relative.x * sensitivity
		camera_3d.rotation.x = camera_3d.rotation.x - event.relative.y * sensitivity
		camera_3d.rotation.x = clamp(camera_3d.rotation.x, deg_to_rad(-90),deg_to_rad(80))

# This function is the physics of the game (delta is time passed since game start)
func _physics_process(delta):
	
	# Handle gravity of player
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Sprint / Walk
	if Input.is_action_pressed("sprint"):
		speed =  RUN_SPEED
	else:
		speed = WALK_SPEED
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		
		if direction != Vector3.ZERO:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 8.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 8.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 2.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 2.0)

	# Mouse inputs
	if Input.is_action_just_pressed("left_click") and not inventory_ui.visible:
		if ray_cast_3d.is_colliding():
			if ray_cast_3d.get_collider().has_method("destroy_block"):
				break_sound.play()
				ray_cast_3d.get_collider().destroy_block(ray_cast_3d.get_collision_point() - ray_cast_3d.get_collision_normal())
				
	if Input.is_action_just_pressed("right_click") and not inventory_ui.visible:
		if ray_cast_3d.is_colliding():
			if ray_cast_3d.get_collider().has_method("place_block"):
				ray_cast_3d.get_collider().place_block(ray_cast_3d.get_collision_point() + ray_cast_3d.get_collision_normal(), block)
				place_sound.play()
	
	# Opens the inventory
	if Input.is_action_just_pressed("inventory"):
		toggle_inventory.emit()
	
	# Navigation of hotbar selector
	if Input.is_action_pressed("scroll_up"):
		HOTBAR_INVENTORY.active_item_scroll_up()
		SLOT._on_hotbar_selected()
		
	elif Input.is_action_pressed("scroll_down"):
		HOTBAR_INVENTORY.active_item_scroll_down()
		SLOT._on_hotbar_selected()
		
	# Adds Head Bob to camera
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera_3d.transform.origin = _headbob(t_bob)
	move_and_slide()


# This function handles the head bobbing
func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos


# This function receives the block id of the block selected in hotbar
func blockID(block_ID: int) -> void:
	block = block_ID

