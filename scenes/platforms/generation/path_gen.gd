extends Line2D

@export var level_length: int = 40
@export var tile_size: int = 200

var current_location: Vector2i = Vector2(0, 0)
var remaining_length: int = 40

func _ready():
	generate()

func generate():
	clear_points()
	
	current_location = Vector2(0, 0)
	remaining_length = level_length
	add_point(current_location)
	
	var vertical = true
	
	while remaining_length > 0:
		vertical = step(vertical)

func step(vertical: bool):
	var direction: Vector2i = ([Vector2i(0, 1), Vector2i(0, -1)] if vertical else [Vector2i(1, 0), Vector2i(-1, 0)]).pick_random()
	var leg_length: int = randi_range(1, 5)
	
	current_location += direction * tile_size * min(leg_length, remaining_length)
	add_point(current_location)
	
	remaining_length -= leg_length
	
	return !vertical
