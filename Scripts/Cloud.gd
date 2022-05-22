extends Sprite

export var total_frames : int;
export var size_min_max : Vector2; # x - min y - max
export var y_min_max : Vector2; 
export var speed_min_max : Vector2;

var speed : float;
func _ready():
	global_position = Vector2(-20, rand_range(y_min_max.x, y_min_max.y));
	var scalar = rand_range(size_min_max.x, size_min_max.y);
	frame = randi()%total_frames;
	flip_h = randi()%3 == 0;
	flip_v = randi()%3 == 0;
	speed = rand_range(speed_min_max.x, speed_min_max.y);
func _process(delta):
	global_position.x += speed * delta;
