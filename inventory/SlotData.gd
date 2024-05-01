extends Resource

# Declaring class name so that it can be receive/connect to other scripts/nodes
class_name  SlotData

# Declaration of variables
const MAX_STACK_SIZE: int = 64

# Takes the class of ItemData for connection purposes
@export var item_data: ItemData
@export_range(1, MAX_STACK_SIZE) var quantity: int = 1: set = set_quantity #This var is the quantity of the items in the inventory


# This function is for combining the same single stackable items into a stack
func can_merge_with(other_slot_data: SlotData) -> bool:
	return item_data == other_slot_data.item_data \
			and item_data.stackable \
			and quantity < MAX_STACK_SIZE


# This function is for combining stacks with different values
func can_fully_merge_with(other_slot_data: SlotData) -> bool:
	return item_data == other_slot_data.item_data \
			and item_data.stackable \
			and quantity + other_slot_data.quantity <= MAX_STACK_SIZE


# This function handles the stack when the quantity is beyond the max stack size
func fully_merge_with(other_slot_data: SlotData) -> void:
	quantity += other_slot_data.quantity


# This function is called when separating the stack and dropping
# Them into a different slot to populate
func create_single_slot_data() -> SlotData:
	var new_slot_data = duplicate()
	new_slot_data.quantity = 1
	quantity -= 1
	return new_slot_data


# This function is for getting the quantity of the of the item
func set_quantity(value: int) -> void:
	quantity = value
	if quantity > 1 and not item_data.stackable:
		quantity = 1
		push_error("%s is not stackable, setting quantity to 1" % item_data.name)
