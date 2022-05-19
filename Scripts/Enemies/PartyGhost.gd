extends Enemy

export var use_line : bool;
export var line_color : Color;

onready var sprite : Sprite = $Icon;

var line : Line2D;
var elapsed : float = 0;

func _ready():
	if !use_line: return;
	line = Line2D.new();
	line.width = 1;
	line.default_color = line_color;
	get_tree().current_scene.call_deferred("add_child",line);
func _process(delta):
	elapsed += delta;
	move();
	if velocity.x != 0:
		 sprite.flip_h = velocity.x < 0;
func on_death():
	if use_line: line.queue_free();
func get_direction():
	if get_tree().current_scene.player == null: return Vector2.ZERO;
	var path = get_tree().current_scene.get_simple_path(global_position,get_tree().current_scene.player.global_position + get_tree().current_scene.player.velocity, is_air);
	if path.size() == 0: return Vector2.ZERO;
	if use_line: line.points = path;
	return (path[1] - global_position).normalized()+Vector2(0,sin(elapsed*2*PI));
