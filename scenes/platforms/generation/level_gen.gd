extends Node2D

@export var platform_target: Node2D

var normal_platform = preload("res://scenes/platforms/platform_normal.tscn")

func _on_path_gen_ready() -> void:
	create_platforms($PathGen)

func create_platforms(path: Line2D):
	pass
