extends KinematicBody2D
tool
class_name Enemy

export var HB : NodePath;
export var animPl : NodePath;
export var max_hp : float;

var hp : float setget set_hp;

func _ready():
	hp = max_hp;
	get_node(HB).connect("area_entered", self, "on_HB_collided");

func set_hp(value : float):
	if value < hp: # hp decreased
		get_node(animPl).play("hurt");
	hp = clamp(value, 0 , max_hp);
	if (hp == 0):
		die();

func _get_configuration_warning():
	if (get_node_or_null(HB) == null):
		return "hitbox isn't set";
	if get_node_or_null(animPl) == null:
		return "animation player isn't set";
	if !(get_node(animPl) is AnimationPlayer):
		return "an animation player must be selected";
	if !get_node(animPl).has_animation("hurt"):
		return "selected animation player must contain 'hurt' animation";
	return "";

func die():
	queue_free();
func on_HB_collided(area : Area2D):
	set_hp(hp - 1);
