extends TextureRect

signal open_info(card_index: int)

@export var card_index: int = 0
@export var is_empty: bool = false

const ICON_PATH: String = "res://images/card_icons/%s"

@onready var config_file: ConfigFile = ConfigFile.new()
@onready var card_name: String = Inventory.inventory[card_index].card_name

var empty_texture = preload("res://images/ui/empty_card_slot.png")

func _ready() -> void:
	if is_empty:
		%CardIcon.queue_free()
		$Card.texture = empty_texture
		return
	
	config_file.load("res://behavior/cards.cfg")
	assert(config_file.has_section(card_name), "Card %s doesn't exist!" % card_name)
	%CardIcon.texture = load(ICON_PATH % config_file.get_value(card_name, "icon"))

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		if is_empty:
			$ImpossibleSFX.play()
			return
		open_info.emit(card_index)
