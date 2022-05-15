extends Gun

export var projectile : PackedScene;
export var proj_speed : float;
export var proj_start_distance : float;

func shoot():
	var P = projectile.instance();
	get_tree().current_scene.add_child(P);
	P.global_position = global_position;
	P.direction = (get_global_mouse_position() - global_position).normalized();
	P.global_position += P.direction * proj_start_distance;
	P.speed = proj_speed;
