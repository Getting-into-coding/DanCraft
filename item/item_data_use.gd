extends ItemData

# Declares the class name of script
class_name ItemDataUse

# Export the variable block_id as an integer
@export var block_id: int

# This function handles the usage of the block
# determined via block_id
func use(target) -> void:
	target.blockID(block_id)
