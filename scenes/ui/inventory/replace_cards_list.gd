extends HBoxContainer
signal card_replaced

var card_scene: PackedScene = preload("res://scenes/ui/inventory/replace_card_card.tscn")

func _ready():
	update_cards()

func update_cards():
	for card_index in range(Inventory.inventory_size):
		if add_empty_card_if(card_index >= len(Inventory.inventory), card_index): continue
		if add_empty_card_if(Inventory.inventory[card_index].is_empty, card_index): continue
		
		var card_instance = card_scene.instantiate()
		card_instance.card_index = card_index
		add_child(card_instance)

func add_empty_card_if(condition: bool, card_index: int) -> bool:
	if not condition: return condition
	var card_instance = card_scene.instantiate()
	card_instance.is_empty = true
	card_instance.card_index = card_index
	add_child(card_instance)
	return condition
