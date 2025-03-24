extends Node2D

@export var card_name: String = "punch"

const ICON_PATH: String = "res://images/card_icons/%s"

@onready var config_file: ConfigFile = ConfigFile.new()

func _ready() -> void:
	config_file.load("res://behavior/cards.cfg")
	assert(config_file.has_section(card_name), "Card %s doesn't exist!" % card_name)
	%CardIcon.texture = load(ICON_PATH % config_file.get_value(card_name, "icon"))

func _on_interacted() -> void:
	var replace_card_ui: Control = get_tree().get_first_node_in_group("replace_card")
	replace_card_ui.open_menu()
	$InteractionArea2D.monitoring = false
