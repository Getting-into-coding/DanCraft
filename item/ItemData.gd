extends Resource

# Declares the class name of script
class_name ItemData

# Export the data of the items in the item folder of the game files
# as variables that the game engine can use
@export var name: String = ""
@export_multiline var description: String = ""
@export var stackable: bool = false
@export var texture: AtlasTexture

# Function for item use
func use(target) -> void:
	pass
