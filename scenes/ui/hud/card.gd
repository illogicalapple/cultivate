extends TextureRect

@export var has_card: bool = true:
	set = has_card_changed
@export var card: String = "punch":
	set = card_changed

@export var inventory_slot: int = 0

@onready var config_file = ConfigFile.new()

const ICON_PATH: String = "res://images/card_icons/%s"

var no_card_texture: Texture2D = preload("res://images/ui/empty_card_slot.png")
var card_texture: Texture2D = preload("res://images/ui/card.png")

func _ready() -> void:
	config_file.load("res://behavior/cards.cfg")
	Inventory.update.connect(_on_inventory_update)
	_on_inventory_update()
	if has_card: card_changed(card)

func _on_inventory_update():
	has_card = not Inventory.inventory[inventory_slot].is_empty
	if not has_card: return
	
	card = Inventory.inventory[inventory_slot].card_name

func card_changed(new_card) -> void:
	has_card = true
	card = new_card
	print(config_file)
	assert(config_file.has_section(new_card), "Card %s doesn't exist!" % new_card)
	$CardIcon.texture = load(ICON_PATH % config_file.get_value(new_card, 'icon'))

func has_card_changed(new_has_card) -> void:
	if has_card == new_has_card: return
	has_card = new_has_card
	
	texture = card_texture if has_card else no_card_texture
	mouse_filter = Control.MOUSE_FILTER_PASS if has_card else Control.MOUSE_FILTER_IGNORE
	if has_card: card_changed(card)
	
	$CardIcon.visible = has_card

## Called when the mini card is dropped.
func trigger() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	$Cooldown.value = 100
	var cooldown_tw: Tween = get_tree().create_tween()
	cooldown_tw.tween_property($Cooldown, "value", 0, config_file.get_value(card, "cooldown"))

func _on_cooldown_value_changed(value: float) -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP if value == 0 else MOUSE_FILTER_IGNORE
