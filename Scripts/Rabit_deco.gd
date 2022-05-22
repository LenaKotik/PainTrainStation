extends Sprite

export var walk_period : int;
export var walk_radius : float;
export var dead_zone : float;
export var freedom_radius : float;
export var speed : float;
export var home : Vector2;

var des : Vector2;
var is_walking : bool = false;

func _ready():
	des = global_position;

func _process(delta):
	if !is_walking and randi() % walk_period*60 == 0:
		des = Vector2.RIGHT.rotated(rand_range(-PI, PI)) * rand_range(0, walk_radius) + global_position;
		if des.distance_to(home) > freedom_radius: 
			des = global_position;
		else:
			$AnimationPlayer.play("walk");
	if global_position.distance_to(des) > dead_zone:
		is_walking = true;
		global_position += global_position.direction_to(des)*speed*delta;
	else:
		$AnimationPlayer.stop();
		is_walking = false;
