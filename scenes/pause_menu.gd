extends Control

# Ready the nodes of the scene as variables
@onready var animation_player = $AnimationPlayer
@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")
@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")
@onready var settings_node = $"Settings Node"
@onready var pause_container = $"Pause Container"

# Exports the InventoryData script as variable
@export var game_manager : ManagerGame

# The initial function to be called when script is run
func _ready():
	game_manager.connect("toggle_game_paused", _on_game_manager_toggle)
	settings_node.hide()
	
# This function handles the toggling of the pause menu
func _on_game_manager_toggle(is_paused : bool):
	if(is_paused):
		animation_player.play("blur")
		show()

		
	else:
		animation_player.play_backwards("blur")
		hide()


# This function allows the resume button to resume the game
func _on_resume_btn_pressed():
	game_manager.game_paused = false


# This function allows the quit button to quit the game
func _on_quit_btn_pressed():
	get_tree().quit()


# This function allows the settings button to open the settings menu
func _on_settings_btn_pressed():
	settings_node.show()
	pause_container.hide()


# This function allows the music slider to change the music volume
func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(MUSIC_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(MUSIC_BUS_ID, value < .05)


# This function allows the SFX slider to change the SFX volume
func _on_sfx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(SFX_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(SFX_BUS_ID, value < .05)


# This button allows the return button to go back from the settings
# to the pause menu
func _on_return_btn_pressed():
	settings_node.hide()
	pause_container.show()
