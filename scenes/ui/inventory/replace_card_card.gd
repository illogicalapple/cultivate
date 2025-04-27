extends TextureRect
signal open_info(card_index: int)

@export var card_index: int = 0
@export var is_empty: bool = false

@export_group("New Card")
@export var new_card_name: String = "dumpling bus"

const ICON_PATH: String = "res://images/card_icons/%s"

@onready var config_file: ConfigFile = ConfigFile.new()
@onready var card_name: String = Inventory.inventory[card_index].card_name

var empty_texture = preload("res://images/ui/empty_card_slot.png")
var full_texture = preload("res://images/ui/card.png")

func _ready() -> void:
	update_texture($CardVisible, card_name, is_empty)

func update_texture(target: TextureRect, card_name: String, is_empty: bool = false):
	if is_empty:
		target.get_node("CardIcon").queue_free()
		target.texture = empty_texture
		return
	
	else:
		target.texture = full_texture
	
	config_file.load("res://behavior/cards.cfg")
	assert(config_file.has_section(card_name), "Card %s doesn't exist!" % card_name)
	target.get_node("CardIcon").texture = load(ICON_PATH % config_file.get_value(card_name, "icon"))

func _on_mouse_entered() -> void:
	$AnimationPlayer.play("hover")

func _on_mouse_exited() -> void:
	$AnimationPlayer.play_backwards("hover")

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		update_texture($TransitionCard, new_card_name)
		Inventory.set_slot(card_index, Inventory.Card.new(new_card_name))
		$AnimationPlayer.play("change_card")
		await $AnimationPlayer.animation_finished
		await get_tree().create_timer(0.5).timeout
		get_parent().card_replaced.emit()
