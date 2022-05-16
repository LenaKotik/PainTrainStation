extends Gun

export var projectile : PackedScene;
export var proj_speed : float;
export var proj_start_distance : float;
export var delay : float;

onready var tmr : Timer = $Timer;

func shoot():
	if !tmr.is_stopped() and delay > 0: return;
	tmr.start(delay);
	var P = projectile.instance();
	get_tree().current_scene.add_child(P);
	P.knock_back = knock_back;
	P.global_position = global_position;
	P.direction = (get_global_mouse_position() - global_position).normalized();
	P.global_position += P.direction * proj_start_distance;
	P.speed = proj_speed;
