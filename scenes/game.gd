extends Node

func _ready():
	Inventory.set_slot(0, Inventory.Card.new("red potion"))
	Inventory.set_slot(1, Inventory.Card.new("nuke"))
	Inventory.set_slot(2, Inventory.Card.new("punch"))
