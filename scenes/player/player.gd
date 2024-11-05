extends Character

func _process(delta: float) -> void:
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity += direction.normalized() * delta * speed
	velocity = velocity.lerp(Vector2.ZERO, 6 * delta)
	
	velocity = collide(velocity)
	
	move(direction, delta)
