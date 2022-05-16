extends Enemy

export var use_line : bool;
export var line_color : Color;

var line : Line2D;

func _ready():
	if !use_line: return;
	line = Line2D.new();
	line.width = 1;
	line.default_color = line_color;
	get_tree().current_scene.call_deferred("add_child",line);
func _process(delta):
	move();
func on_death():
	line.queue_free();
func get_direction():
	if get_tree().current_scene.player == null: return Vector2.ZERO;
	var path = get_tree().current_scene.nav.get_simple_path(global_position,get_tree().current_scene.player.global_position + get_tree().current_scene.player.velocity);
	if use_line: line.points = path;
	return (path[1] - global_position).normalized();
