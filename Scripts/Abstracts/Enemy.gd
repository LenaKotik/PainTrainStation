extends Actor
class_name Enemy
tool

export var HB : NodePath;
export var animPl : NodePath;
export var max_hp : float;
export var dmg : float;
export var knock_back : float;
export var is_air : bool;

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
	on_death();
	queue_free();
func on_death():
	pass;
func on_HB_collided(area : Area2D):
	if "projectile" in area.get_groups():
		set_hp(hp - area.dmg);
		velocity += (global_position-area.global_position) * area.knock_back;
