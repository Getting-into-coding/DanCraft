extends GridMap

# This function tells the GridMap that a targeted by the
# raycast 3d from the player scene
# is to be destroyed at that coordinate
func destroy_block(world_coordinate):
	var map_coordinate = local_to_map(world_coordinate)
	set_cell_item(map_coordinate, -1)

# This function tells the GridMap that a targeted by the
# raycast 3d from the player scene
# is to be placed at that coordinate
func place_block(world_coordinate, block_index):
	var map_coordinate = local_to_map(world_coordinate)
	set_cell_item(map_coordinate, block_index)
