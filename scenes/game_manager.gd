extends Node

# Set the class name of the script
class_name ManagerGame

# This signal is sent to the pause menu to toggle paused and unpaused
signal toggle_game_paused(is_paused : bool)

# Ready the world node as a variable
@onready var world = $world

# Preloads the world scene as a constant
const World = preload("res://scenes/world.gd")

# This is variable with a getter and setter to
# switch between pause and unpaused based on the
# current status of the scene tree
var game_paused : bool = false:
	get:
		return game_paused
	set(value):
		game_paused = value
		get_tree().paused = game_paused
		if game_paused == true:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		elif game_paused == false:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		emit_signal("toggle_game_paused", game_paused)

# This function listens for the input "escape key" (set as "pause")
# to call/toggle the value of the game_paused variable
func _input(event : InputEvent):
	if event.is_action_pressed("pause"):
		game_paused = !game_paused
