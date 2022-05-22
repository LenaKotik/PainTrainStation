extends Node2D
class_name Level

export var nav_air : NodePath;
export var nav_ground : NodePath;
export var UI : NodePath;

onready var player = $Player;

func setup():
	get_node(UI).set_max_hp(player.max_hp);
	player.connect("hp_changed", get_node(UI), "set_hp");
	player.connect("ptr_changed", get_node(UI), "select_weapon");
	player.connect("weapon_added", get_node(UI), "add_weapon");
	player.connect("weapon_removed", get_node(UI), "remove_weapon");
	player.connect("died", get_node(UI), "died");

func get_simple_path(a : Vector2, b : Vector2, by_air : bool):
	if by_air:
		return get_node(nav_air).get_simple_path(a, b);
	else:
		return get_node(nav_ground).get_simple_path(a, b);
func get_closest_point(to : Vector2, by_air : bool):
	if by_air:
		return get_node(nav_air).get_closest_point(to);
	else:
		return get_node(nav_ground).get_closest_point(to);
func _process(_delta):
	if (Input.is_action_just_pressed("restart")):
		get_tree().reload_current_scene();
