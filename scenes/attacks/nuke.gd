extends Node2D

@onready var player = get_tree().get_first_node_in_group(&"player")

func damage() -> void:
	print("a")
	$ShapeCast2D.force_shapecast_update()
	if not $ShapeCast2D.is_colliding(): return
	for collider in range($ShapeCast2D.get_collision_count()):
		var target_body = $ShapeCast2D.get_collider(collider).get_parent()
		target_body.damage(100, player, "you nuked yourself (???)", target_body.global_position - global_position, 2)

func _on_explode_animation_animation_finished(_anim_name: StringName) -> void:
	queue_free()
