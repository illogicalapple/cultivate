extends Sprite2D

# TODO: change excessive damage back to 20s

func _ready() -> void:
	$ShapeCast2D.force_shapecast_update()
	if not $ShapeCast2D.is_colliding(): return
	for collider in range($ShapeCast2D.get_collision_count()):
		$ShapeCast2D.get_collider(collider).get_parent().damage(20, get_tree().get_first_node_in_group(&"player"), "you punched yourself (how?)")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
