extends PanelContainer

# These signals communicate with the inventory and the hotbar
signal slot_clicked (index: int, button: int)
signal hotbar_selected (itemname: String)

# Ready the nodes as variable
@onready var texture_rect = $MarginContainer/TextureRect
@onready var quantity_label = $QuantityLabel

# This index is for the position of the hotbar selector
var index = [0,0]


# This function sets the SlotData of the slot
func set_slot_data(slot_data: SlotData) -> void:
	var item_data = slot_data.item_data
	texture_rect.texture = item_data.texture
	tooltip_text = "%s\n%s" % [item_data.name, item_data.description]

	if slot_data.quantity > 1:
		quantity_label.text = "x%s" % slot_data.quantity
		quantity_label.show()
	else:
		quantity_label.hide()


# This function is called when the hotbar selector has been used
# and updates the index in this script
func update_index(new_value: int) -> void:
	index[1] = new_value


# This function gets the index of the selector of the hotbar
# and uses that to send a signal to the hotbar node on what
# item has been selected
func _on_hotbar_selected(selected_index: int) -> void:
	if selected_index == index[0]:
		var inventory_data = get_node("MarginContainer/ItemGrid").get_inventory_data()
		var item_data = inventory_data.slot_datas[[0,1]].item_data
		if item_data:
			hotbar_selected.emit(item_data.name)
		else:
			hotbar_selected.emit("")


# This function is for determining what slot has been
# clicked by the player in the inventory and
# sends that signal to the inventory node
func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
			and (event.button_index == MOUSE_BUTTON_LEFT \
			or event.button_index == MOUSE_BUTTON_RIGHT) \
			and event.is_pressed():
		slot_clicked.emit(get_index(), event.button_index)
