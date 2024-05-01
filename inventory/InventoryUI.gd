extends Control

# Set the class SlotData as variable
var grabbed_slot_data: SlotData

# Ready the scene nodes as variables
@onready var player_inventory = $PlayerInventory
@onready var grabbed_slot = $GrabbedSlot

# This function allows the moving of grabbed items while the game is running
# and the inventory is opened
func _physics_process(delta: float) -> void:
	if grabbed_slot.visible:
		grabbed_slot.global_position = get_global_mouse_position() + Vector2(5,5)


# This function sets the inventory of the player based on the inventory data
func set_player_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_interact.connect(on_inventory_interact)
	player_inventory.set_player_inventory_data(inventory_data)


# This function handles the mouse inputs when an item in the inventory is
# interacted with
func on_inventory_interact(inventory_data: InventoryData, index: int, button: int) -> void:
	
	match [grabbed_slot_data, button]:
		# Pick Up Item
		[null, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.grab_slot_data(index)
		[_, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.drop_slot_data(grabbed_slot_data, index)
			
		# Drop Item
		[null, MOUSE_BUTTON_RIGHT]:
			inventory_data.use_slot_data(index)
		[_, MOUSE_BUTTON_RIGHT]:
			grabbed_slot_data = inventory_data.drop_single_slot_data(grabbed_slot_data, index)
	update_grabbed_slot()
	
# This function updates the inventory when a player moves or modifies the stack
# of items in the inventory
func update_grabbed_slot() -> void:
	if grabbed_slot_data:
		grabbed_slot.show()
		grabbed_slot.set_slot_data(grabbed_slot_data)
	else:
		grabbed_slot.hide()
