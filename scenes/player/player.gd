extends CharacterBody2D

@export var speed: float = 800

var facing: int = 1

func _process(delta: float) -> void:
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity += direction.normalized() * delta * speed
	velocity = velocity.lerp(Vector2.ZERO, 3 * delta)
	move_and_slide()
	
	if velocity.distance_to(Vector2.ZERO) > 40 or direction != Vector2.ZERO:
		%RunAnim.speed_scale = velocity.distance_to(Vector2.ZERO) / 50 + 0.3
		if (not %RunAnim.is_playing()) or %RunAnim.current_animation != "run": %RunAnim.play("run")
	else:
		%RunAnim.speed_scale = 2
		%RunAnim.play("idle")
	
	if sign(velocity.x) != facing and sign(velocity.x) != 0:
		facing = sign(velocity.x)
		var scale_tw = get_tree().create_tween() \
			.set_trans(Tween.TRANS_CUBIC)
		
		scale_tw.tween_property($AnimatedSprite2D, "scale", Vector2(- facing, 1), 0.15)
