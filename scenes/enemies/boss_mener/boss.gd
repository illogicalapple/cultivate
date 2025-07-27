extends Character

@export var dashing_speed: float = 1000.0

var minion: PackedScene = preload("res://scenes/enemies/cultivator/cult_member.tscn")
var target: Character
var activated: bool = false

# state machine logic
var state: State = State.IDLE: set = new_state
var attention_span: float = INF

var dashing_direction: Vector2
var dashing_time: float

var off_screen: bool = false

var process_timer: bool = false

enum State {
	SPAWNING_MINIONS,
	DASHING,
	BULLETS,
	IDLE
}

@onready var screen_size: Vector2 = get_viewport_rect().size

func new_state(new_state: State):
	state = new_state
	
	match state:
		State.SPAWNING_MINIONS:
			spawn_minions()
			attention_span = 2
		State.DASHING:
			attention_span = 5
			var rad: float = randf_range(0, PI)
			var cam: Camera2D = get_viewport().get_camera_2d()
			dashing_direction = Vector2(cos(rad), sin(rad))
			dashing_time = 4
			
			var rectangle_pos: Vector2
			var adjusted_size: Vector2 = screen_size
			if rad < PI / 2:
				rectangle_pos = Vector2((adjusted_size.x / 2) + (adjusted_size.y / 2) * tan(rad), 0)
			else:
				rectangle_pos = Vector2(adjusted_size.x, (adjusted_size.x / 2) - (adjusted_size.y / 2) * tan(rad - (PI / 2)))
			
			var curve: Curve2D = %DashPath.curve
			curve.clear_points()
			curve.add_point(rectangle_pos + target.global_position)
			curve.add_point(target.global_position - rectangle_pos)
			%DashLine.points = curve.get_baked_points()
			$CollisionShape2D.disabled = true
			

func state_process(delta) -> void:
	attention_span -= delta
	
	match state:
		State.SPAWNING_MINIONS:
			if attention_span <= 0: state = State.DASHING
		State.DASHING:
			dashing_time -= delta
			# velocity = dashing_direction * dashing_speed
			
			if dashing_time > 0 or off_screen: return
			velocity = Vector2.ZERO
			
			if process_timer: return
			process_timer = true
			await get_tree().create_timer(0.5).timeout
			process_timer = false
			
			if attention_span > 0: 
				state = State.DASHING # start new dash
				return
			
			$CollisionShape2D.disabled = false
			state = State.SPAWNING_MINIONS

func _process(delta) -> void:
	move(velocity, delta)
	velocity = velocity.lerp(Vector2.ZERO, 6 * delta)
	velocity = collide(velocity)
	
	state_process(delta)

func spawn_minions():
	for cast in %MinionCasts.get_children():
		(cast as RayCast2D).force_raycast_update()
		if not (cast as RayCast2D).is_colliding():
			continue
		
		var instance: Character = minion.instantiate()
		instance.global_position = cast.global_position
		add_sibling(instance)
		
		instance.activate(target)

func _on_damaged(_amount: float, origin: Character) -> void:
	target = origin
	if not activated: activate()

func activate(origin: Character = self) -> void:
	if origin != self:
		target = origin
	
	activated = true
	
	state = State.SPAWNING_MINIONS
