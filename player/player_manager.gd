extends Node

# Instatiation of variable
var player


# This function handles the player using the item
func use_slot_data(slot_data: SlotData) -> void:
	slot_data.item_data.use(player)
	pass
