extends Node

func _ready() -> void:
	get_tree().get_first_node_in_group("main_menu").play()
