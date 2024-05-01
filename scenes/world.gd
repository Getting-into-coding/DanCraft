extends Node3D

# Ready the nodes as variables
@onready var player = $player
@onready var inventory_ui = $UI/InventoryUI
@onready var hotbar_inventory = $UI/HotbarInventory


# The initial function to be called when script is run
func _ready() -> void:
	player.toggle_inventory.connect(toggle_inventory_interface)
	inventory_ui.set_player_inventory_data(player.inventory_data)
	hotbar_inventory.set_inventory_data(player.inventory_data)


#This function toggles the visibility of the inventory ui
func toggle_inventory_interface() -> void:
	inventory_ui.visible = not inventory_ui.visible
	
	if inventory_ui.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		hotbar_inventory.hide()
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		hotbar_inventory.show()
		

