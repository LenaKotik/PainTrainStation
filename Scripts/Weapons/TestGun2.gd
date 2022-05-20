extends Gun

export var projectile : PackedScene;
export var spread : float;
export var amount : int;
export var delay : float;
export var proj_speed : float;
export var proj_dmg : float;
export var proj_start_distance : float;
export var proj_rot : float;

onready var tmr : Timer = $Timer;

func shoot():
	if !tmr.is_stopped() and delay > 0: return;
	tmr.start(delay);
	for _i in range(amount):
		var P = projectile.instance() as Area2D;
		get_tree().current_scene.add_child(P);
		P.rotation_applied = proj_rot;
		P.global_position = global_position + global_position.direction_to(get_global_mouse_position()) * proj_start_distance;
		P.dmg = proj_dmg;
		P.speed = proj_speed;
		P.knock_back = knock_back;
		P.direction = global_position.direction_to(get_global_mouse_position()).rotated(deg2rad(rand_range(-spread/2, spread/2)));
