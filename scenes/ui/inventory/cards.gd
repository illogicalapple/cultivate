extends HFlowContainer

@export var info_anim: AnimationPlayer

var card_scene: PackedScene = preload("res://scenes/ui/inventory/inventory_card.tscn")

func _ready():
	update_cards()

func update_cards():
	for card_index in range(Inventory.inventory_size):
		if add_empty_card_if(card_index >= len(Inventory.inventory)): continue
		if add_empty_card_if(Inventory.inventory[card_index].is_empty): continue
		
		var card_instance = card_scene.instantiate()
		card_instance.card_index = card_index
		add_child(card_instance)
		
		card_instance.open_info.connect(_on_info_opened)

func _on_info_opened(card_index: int):
	info_anim.play("in")

func add_empty_card_if(condition: bool) -> bool:
	if not condition: return condition
	var card_instance = card_scene.instantiate()
	card_instance.is_empty = true
	add_child(card_instance)
	return condition
