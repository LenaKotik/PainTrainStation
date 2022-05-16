extends KinematicBody2D
class_name Actor
tool

export var speed : float;
export var friction : float;
export var particles_path : NodePath;

var particles : Particles2D;
var can_move : bool = true;
var velocity : Vector2 = Vector2.ZERO;

func _get_configuration_warning():
	if particles_path == "":
		return "particles aren't set";

func _ready():
	particles = get_node_or_null(particles_path);

func move():
	if (can_move):
		var direction = get_direction();
		velocity += direction * speed;
		velocity = lerp(velocity, Vector2.ZERO, friction);
	move_and_slide(velocity, Vector2.ZERO);

func get_direction() -> Vector2:
	return Vector2.ZERO;
