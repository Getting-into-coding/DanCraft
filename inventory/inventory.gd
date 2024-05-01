extends PanelContainer

# Preload the slot node into a constant
const Slot = preload("res://inventory/slot.tscn")

# Ready the GridContainer node as a variable to be used in
# the script
@onready var item_grid: GridContainer = $MarginContainer/ItemGrid


# This function gets the inventory data and calls the populate function
# to fill the inventory with the items
func set_player_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_updated.connect(populate_item_grid)
	populate_item_grid(inventory_data)


# This function populates the inventory via the item data send by the
# set_player_inventory_data function by iterating through the data
func populate_item_grid(inventory_data: InventoryData) -> void:
	for child in item_grid.get_children():
		child.queue_free()
		
	for SlotData in inventory_data.slot_datas:
		var slot = Slot.instantiate()
		item_grid.add_child(slot)
		
		slot.slot_clicked.connect(inventory_data.on_slot_clicked)
		
		if SlotData:
			slot.set_slot_data(SlotData)

