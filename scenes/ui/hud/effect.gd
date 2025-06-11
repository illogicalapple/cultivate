extends HBoxContainer

signal effect_over(effect_name: String)

@export var effect: String

@onready var effect_cfg = ConfigFile.new()
@onready var player: Character = get_tree().get_first_node_in_group("player")

func _ready():
	effect_cfg.load("res://behavior/effects.cfg")
	
	%Name.text = effect
	%Icon.texture = load("res://images/effect_icons/%s" % effect_cfg.get_value(effect, "icon"))
	
	player.effects.get_effect(effect).effect_over.connect(on_effect_over)

func _process(delta: float) -> void:
	if not is_instance_valid(player.effects.get_effect(effect)): return
	%Time.text = str(floori(player.effects.get_effect(effect).get_time_left())) + "s"

func on_effect_over(effect_name: String):
	effect_over.emit(effect_name)
	
	$AnimationPlayer.play_backwards("in")
	await $AnimationPlayer.animation_finished
	queue_free()
