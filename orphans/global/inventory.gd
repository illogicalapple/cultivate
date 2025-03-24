extends Node

signal update

class Card extends Object:
	var card_name: String = "punch"
	var is_empty: bool = false
	func _init(card_name: String, is_empty: bool = false) -> void:
		self.card_name = card_name
		self.is_empty = is_empty

var inventory: Array[Card] = [Card.new("punch"), Card.new("empty", true), Card.new("empty", true)]
var inventory_size: int = 3

func set_slot(card_index: int, new_card: Card):
	assert(card_index < inventory_size, "Card index out of bounds")
	inventory[card_index] = new_card
	
	update.emit()
