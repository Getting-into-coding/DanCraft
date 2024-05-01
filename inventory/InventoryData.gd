extends Resource

# Declare class name of script
class_name InventoryData

# Send signals to be connected to the inventory ui
signal inventory_updated(inventory_data: InventoryData)
signal inventory_interact(inventory_data: InventoryData, index: int, button: int)

# Export the array of SlotData as an a variable array
@export var slot_datas: Array[SlotData]


# This function handles the the slot data of the grabbed
# item in the inventory by the player
func grab_slot_data(index: int) -> SlotData:
	var slot_data = slot_datas[index]
	
	if slot_data:
		slot_datas[index] = null
		inventory_updated.emit(self)
		return slot_data
	else:
		return null


# This function handles the slot data of the entire dropped
# item stack in the inventory by the player
func drop_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	var slot_data = slot_datas[index]
	var return_slot_data: SlotData
	
	if slot_data and slot_data.can_fully_merge_with(grabbed_slot_data):
		slot_data.fully_merge_with(grabbed_slot_data)
	else:
		slot_datas[index] = grabbed_slot_data
		return_slot_data = slot_data
		
	inventory_updated.emit(self)
	return return_slot_data


# This function handles the slot data of the dropped
# item in the inventory by the player when the dropped item
# is placed one at a time in the inventory
func drop_single_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	var slot_data = slot_datas[index]
	
	if not slot_data:
		slot_datas[index] = grabbed_slot_data.create_single_slot_data()
	elif slot_data.can_merge_with(grabbed_slot_data):
		slot_data.fully_merge_with(grabbed_slot_data.create_single_slot_data())
		
	inventory_updated.emit(self)
	
	if grabbed_slot_data.quantity > 0:
		return grabbed_slot_data
	else:
		return null


# This function handles when the item in the inventory slot is used
func use_slot_data(index: int) -> void:
	var slot_data = slot_datas[index]
	
	if not slot_data:
		return
	
	#print(slot_data.item_data.name)
	PlayerManager.use_slot_data(slot_data)
	inventory_updated.emit(self)

func on_slot_clicked (index: int, button: int) -> void:
	inventory_interact.emit(self, index, button)
