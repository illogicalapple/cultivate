extends CharacterBody2D

@export var speed: float = 1400

var facing: int = 1
var animation_queue: StringName = &""

func _process(delta: float) -> void:
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity += direction.normalized() * delta * speed
	velocity = velocity.lerp(Vector2.ZERO, 6 * delta)
	move_and_slide()
	
	if velocity.distance_to(Vector2.ZERO) > 900 or direction != Vector2.ZERO:
		%RunAnim.speed_scale = velocity.distance_to(Vector2.ZERO) / 50 + 0.3
		if (not %RunAnim.is_playing()) or %RunAnim.current_animation != "run": %RunAnim.play("run")
		animation_queue = &""
	else:
		%RunAnim.speed_scale = 2
		animation_queue = &"idle"
	
	if sign(velocity.x) != facing and sign(velocity.x) != 0:
		facing = sign(velocity.x)
		var scale_tw = get_tree().create_tween() \
			.set_trans(Tween.TRANS_CUBIC)
		
		scale_tw.tween_property($AnimatedSprite2D, "scale", Vector2(- facing, 1), 0.15)

func check_queue():
	if animation_queue == &"": return
	%RunAnim.play(animation_queue)
	animation_queue = &""

func _on_run_anim_current_animation_changed(name: String) -> void:
	$AnimatedSprite2D.animation = name
