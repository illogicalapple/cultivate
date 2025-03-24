extends Projectile2D

@export var facing: int = 1

@onready var rotational_velocity: float = randf_range(-300, 300) * facing

func _process(delta):
	position += velocity * delta
	$Sprite2D.rotation_degrees += rotational_velocity * delta
	
	velocity.y += delta * 980
