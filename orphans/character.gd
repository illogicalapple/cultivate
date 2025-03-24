class_name Character extends CharacterBody2D

signal damaged(amount: float, origin: Character)
signal death(origin: Character)

@export var speed: float = 1400
@export var max_health: float = 100
@export var kb_coefficient: float = 400.0
@export var disabled: bool = false
@export_range(-1, 1) var start_facing: int = 1

var facing: int = 1
var animation_queue: StringName = &""

@onready var health: float = max_health

func _ready() -> void:
	facing = start_facing
	$AnimatedSprite2D.scale.x = -facing

func move(direction, delta):
	if disabled: return
	
	move_and_slide()
	
	if (velocity.distance_to(Vector2.ZERO) > 900 or direction != Vector2.ZERO) and velocity.distance_to(Vector2.ZERO) > 40:
		%RunAnim.speed_scale = max(velocity.distance_to(Vector2.ZERO) / 50, 2)
		if (not %RunAnim.is_playing()) or %RunAnim.current_animation != "run": %RunAnim.play("run")
		animation_queue = &""
	else:
		%RunAnim.speed_scale = 2
		animation_queue = &"idle"
	
	if sign(velocity.x + start_facing / 1000) != facing and sign(velocity.x) != 0:
		facing = sign(velocity.x + start_facing / 1000)
		
		var scale_tw = get_tree().create_tween() \
			.set_trans(Tween.TRANS_CUBIC)
		scale_tw.tween_property($AnimatedSprite2D, "scale", Vector2(- facing, 1), 0.15)

func collide(velocity: Vector2) -> Vector2:
	if disabled: return Vector2(0, 0)
	
	$XCast.position = Vector2.ZERO
	$XCast.target_position = Vector2.ZERO
	$XCast.position.x = sign(velocity.x) * 35
	$XCast.target_position.x = sign(velocity.x) * 5
	$XCast.force_raycast_update()
	
	$YCast.position = Vector2.ZERO
	$YCast.target_position = Vector2.ZERO
	$YCast.position.y = sign(velocity.y) * 15
	$YCast.target_position.y = sign(velocity.y) * 5
	$YCast.force_raycast_update()

	return Vector2(velocity.x if $XCast.is_colliding() else 0, velocity.y if $YCast.is_colliding() else 0)

func check_queue() -> void:
	if animation_queue == &"": return
	%RunAnim.play(animation_queue)
	animation_queue = &""

func _on_run_anim_current_animation_changed(name: String) -> void:
	if ($AnimatedSprite2D as AnimatedSprite2D).sprite_frames.has_animation(name):
		$AnimatedSprite2D.animation = name
	else:
		$AnimatedSprite2D.animation = "idle"

func damage(amount: float, origin: Character, projectile_velocity: Vector2 = Vector2(40000, 0)):

	health -= amount
	velocity += (global_position - origin.position if projectile_velocity == Vector2(40000, 0) else projectile_velocity).normalized() * kb_coefficient
	
	damaged.emit(amount, origin)
	if health <= 0: death.emit(origin)
