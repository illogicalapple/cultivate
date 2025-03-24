extends Control

var inventory_open: bool = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		toggle_inventory()

func toggle_inventory():
	if inventory_open:
		close_inventory()
	else:
		open_inventory()

func close_inventory():
	hide()
	
	inventory_open = false
	AudioServer.set_bus_effect_enabled(1, 0, false)

func open_inventory():
	show()
	
	inventory_open = true
	AudioServer.set_bus_effect_enabled(1, 0, true)
