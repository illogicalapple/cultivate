extends VBoxContainer

var effect_scene: PackedScene = preload("res://scenes/ui/hud/effect.tscn")
var displayed_effects_list: Array[String] = []

@onready var player: Character = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	player.effects.effect_added.connect(on_effect_added)

func on_effect_added(effect_name: String, effect_duration: float) -> void:
	if displayed_effects_list.has(effect_name): return # effect overriding stuff is already handled
	
	var effect_instance: HBoxContainer = effect_scene.instantiate()
	effect_instance.effect = effect_name
	add_child(effect_instance)
