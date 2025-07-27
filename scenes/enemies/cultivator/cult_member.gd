extends Character

@export var attack_distance_squared: float = 15000
@export var attack_cooldown: float = 1

var rice_drop_scene: PackedScene = preload("res://scenes/vfx/rice_particle.tscn")
var onigiri_attack_scene: PackedScene = preload("res://scenes/attacks/enemy_onigiri.tscn")

# TODO: figure out anger levels!

var will_activate: bool = false
var activated: bool = false:
	set(new_value):
		activated = new_value
		$CollisionShape2D.disabled = not activated
		%SightCast.enabled = not activated
var target: Node

func _ready() -> void:
	super()
	$AttackTimer.wait_time = attack_cooldown

func _process(delta) -> void:
	if disabled: return
	
	if activated:
		# movement mode
		if Vector2.ZERO.distance_squared_to(target.global_position - global_position) > attack_distance_squared:
			if not $AttackTimer.is_stopped():
				$AttackTimer.stop()
			var direction = target.global_position - global_position
			velocity += direction.normalized() * delta * speed
			velocity = velocity.lerp(Vector2.ZERO, 6 * delta)
			velocity = collide(velocity)
			move(direction, delta)
		# attack mode. See begin_throw
		else:
			velocity = velocity.lerp(Vector2.ZERO, 6 * delta)
			velocity = collide(velocity)
			move(Vector2.ZERO, delta)
			if $AttackTimer.is_stopped():
				begin_throw()
				$AttackTimer.wait_time = attack_cooldown
				$AttackTimer.start()
	else:
		move(Vector2.ZERO, delta)
	
	if %SightCast.is_colliding() and not will_activate:
		%RunAnim.play("alert")
		%RunAnim.queue("idle")
		target = %SightCast.get_collider()
		will_activate = true

func activate(origin: Character = self) -> void:
	if origin != self:
		target = origin
		
	activated = true

func _on_damaged(amount: float, origin: Character) -> void:
	target = origin
	if will_activate and not activated:
		if %RunAnim.current_animation == "alert": %RunAnim.seek(40, true, true)
	
	activate()

func _on_death(_origin: Character, _death_message: String) -> void:
	disabled = true
	%RunAnim.play("death")
	$HealthBar.hide()
	$AttackTimer.stop()

func _on_run_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "death":
		var rice_drop = rice_drop_scene.instantiate()
		rice_drop.value = 1
		rice_drop.global_position = global_position
		add_sibling(rice_drop)
		
		queue_free()

## called on timer timeout. Begins animation which then triggers real throw
func begin_throw() -> void:
	%RunAnim.play("throw")
	%RunAnim.queue("idle")
	
	$AttackTimer.wait_time = attack_cooldown

## triggered through animation
func throw_onigiri() -> void:
	var onigiri = onigiri_attack_scene.instantiate()
	onigiri.global_position = global_position + Vector2(29 * facing, -29) # Magic number. Check end of animation for accuracy
	onigiri.facing = facing
	onigiri.velocity = Vector2(facing * 900, 0)
	onigiri.death_message = "you took a rice ball to the face"
	onigiri.damage_amount = 20
	onigiri.origin = self
	add_sibling(onigiri)
