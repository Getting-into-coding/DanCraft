extends VBoxContainer

# This function allows the new game button to change the scene
# to the world scene 
func _on_newgamebutton_pressed():
	get_tree().change_scene_to_file("res://scenes/game_play.tscn")


# This function allows the quit button to quit the game
func _on_quitbutton_pressed():
	get_tree().quit()
