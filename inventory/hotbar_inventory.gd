extends PanelContainer

# Send signals to be connected to the player script
signal hot_bar_use(index: int)
signal active_item_updated

# Ready the scene nodes as variables
@onready var h_box_container = $MarginContainer/HBoxContainer
@onready var selector = $Selector
@onready var slots: Array = h_box_container.get_children()

# Preload the Slot scene as a constant
const  Slot = preload("res://inventory/slot.tscn")

# This constant sets the size of the hotbar
const NUM_HOTBAR_SLOT = 6

# This variable determines what hotbar slot is
# currently selected 
var currently_selected: int  = 1


# This function moves the hotbar selector value down the hotbar
# and emits the signal of the position to the player script
func move_selector_down() -> void:
	currently_selected = (currently_selected + 1) % NUM_HOTBAR_SLOT
	selector.global_position = slots[currently_selected].global_position
	hot_bar_use.emit(currently_selected)


# This function moves the hotbar selector value up the hotbar
# and emits the signal of the position to the player script
func move_selector_up() -> void:
	if currently_selected == 0:
		currently_selected = NUM_HOTBAR_SLOT - 1
	else:
		currently_selected -= 1
	selector.global_position = slots[currently_selected].global_position
	hot_bar_use.emit(currently_selected)
	#print(currently_selected)


# This function calls the selector up and down function when mouse input
# is done by the player. 
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_pressed("scroll_up"):
		move_selector_up()
		
	elif Input.is_action_pressed("scroll_down"):
		move_selector_down()


# This function gets the inventory data from the inventory
# in order to populate the hotbar
func set_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_updated.connect(populate_hot_bar)
	populate_hot_bar(inventory_data)
	hot_bar_use.connect(inventory_data.use_slot_data)


# This function populates the hotbar by using the data
# gathered from the set_inventory_function and slicing it populating
# the hotbar with only the first six (6) items of the inventory
func populate_hot_bar(inventory_data: InventoryData) -> void:
	for child in h_box_container.get_children():
		child.queue_free()
		
	slots.clear()
	
	for SlotData in inventory_data.slot_datas.slice(0,6):
		var slot = Slot.instantiate()
		h_box_container.add_child(slot)
		
		slots.append(slot)
		 
		if SlotData:
			slot.set_slot_data(SlotData)
			
	hot_bar_use.emit(0, currently_selected)
