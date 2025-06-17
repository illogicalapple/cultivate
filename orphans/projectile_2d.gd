extends Area2D
class_name Projectile2D

signal hit(target: Character)

@export var damage_amount: float = 0
@export var origin: Character
@export var death_message: String = "unnamed projectile killed you"

var velocity: Vector2 = Vector2.ZERO

func _init():
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	var target_character: Character = area.get_parent()
	
	assert(target_character is Character, "Projectile %s collided with body %s, which is not a Character." % [name, target_character.name])
	(target_character as Character).damage(damage_amount, origin, death_message, velocity)
	hit.emit(target_character)
	
	# TODO: add fancy effects here
	queue_free()
