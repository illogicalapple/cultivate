extends Control

@export var path_to_load: String = "res://scenes/game.tscn"
var scene_to_load: PackedScene

@onready var config_file = ConfigFile.new()

func _ready():
	config_file.load("res://behavior/tips.cfg")
	
	%Goober/RunAnim.seek(0.5, true, false)
	%Tip.text = "tip: %s" % config_file.get_value("tips", "all", ["something went wrong"]).pick_random()

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	if scene_to_load:
		return get_tree().change_scene_to_packed(scene_to_load)
	scene_to_load = load(path_to_load)
	$AnimationPlayer.play("out")
