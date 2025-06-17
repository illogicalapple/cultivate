extends TextureRect

signal triggered

@export var effect_scene: PackedScene
@export var card: String
@export var is_menu: bool = false

## Size of the AOE sprite png (circle). Check multiplier in figma
@export var aoe_sprite_size: float = 400

@onready var config_file = ConfigFile.new()

const ICON_PATH: String = "res://images/card_icons/%s"
const EFFECT_PATH: String = "res://scenes/attacks/%s"

var disabled: bool = false

func _ready() -> void:
	config_file.load("res://behavior/cards.cfg")
	
	assert(config_file.has_section(card), "Card %s doesn't exist!" % card)
	$CardIcon.texture = load(ICON_PATH % config_file.get_value(card, "icon"))
	
	effect_scene = load(EFFECT_PATH % config_file.get_value(card, "effect"))
	
	if config_file.has_section_key(card, "radius"):
		var aoe_scale: float = config_file.get_value(card, "radius") / aoe_sprite_size * 2 # mult for radius
		$RangeRadius.show()
		$RangeRadius.scale = Vector2(aoe_scale, aoe_scale)

func _process(delta):
	var mouse_position = get_global_mouse_position()
	global_position = global_position.lerp(mouse_position, 16 * delta)

func _input(event: InputEvent) -> void:
	if disabled: return
	if event.is_action_released("drag_card"):
		disabled = true
		$AnimationPlayer.play("drop")
		play_effect()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == &"drop": queue_free()

func play_effect():
	var effect_instance = effect_scene.instantiate()
	if not is_menu: effect_instance.global_position = (get_global_mouse_position() - get_viewport_rect().size / 2) / get_viewport().get_camera_2d().zoom + get_viewport().get_camera_2d().global_position
	get_parent().add_sibling(effect_instance)
	triggered.emit()
