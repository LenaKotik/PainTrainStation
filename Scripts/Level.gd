extends Node2D
class_name Level

export var nav_air : NodePath;
export var nav_ground : NodePath;

onready var player = $Player;


func get_simple_path(a : Vector2, b : Vector2, by_air : bool):
	if by_air:
		return get_node(nav_air).get_simple_path(a, b);
	else:
		return get_node(nav_ground).get_simple_path(a, b);

func _process(_delta):
	if (Input.is_action_just_pressed("restart")):
		get_tree().reload_current_scene();
