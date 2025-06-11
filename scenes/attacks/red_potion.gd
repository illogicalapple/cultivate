extends Node2D

@onready var player: Character = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	player.effects.add_effect("regeneration", 4)

func _process(delta: float) -> void:
	global_position = player.global_position + Vector2(0, -64)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
