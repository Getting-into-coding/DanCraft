extends Node3D

# Ready the camera pivot node as a variable
@onready var camera_pivot = $CameraPivot

# This variable is the rotation speed of the camera
# in the main menu
var rotation_speed = 8

# Ready nothing, just pass
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame
# pivots the camera to rotate around the island in the main menu
func _process(delta):
	camera_pivot.rotation_degrees.y += delta * rotation_speed
