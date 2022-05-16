extends Enemy

export var use_line : bool;
export var line_color : Color;
export var projectile : PackedScene;
export var proj_speed : float;
export var proj_knock_back : float;
export var proj_dmg : float;
export var desired_range : float;

var line : Line2D;
var phi : float = 0;

onready var tmr : Timer = $ShootInterval;

func _ready():
	if !use_line: return;
	
	line = Line2D.new();
	line.width = 1;
	line.default_color = line_color;
	get_tree().current_scene.call_deferred("add_child",line);
	
	tmr.connect("timeout", self, "shoot");

func _process(delta):
	move();

func on_death():
	line.queue_free();

func get_direction():
	if get_tree().current_scene.player == null: return Vector2.ZERO;
	
	var actual_range : float = global_position.distance_to(get_tree().current_scene.player.global_position);
	
	if (actual_range == desired_range): return Vector2.ZERO;
	var dir : Vector2 = (global_position - get_tree().current_scene.player.global_position).normalized().rotated(phi);
	var to : Vector2 = get_tree().current_scene.player.global_position + dir * (desired_range);
	
	var path = get_tree().current_scene.nav.get_simple_path(global_position,to);
	
	if use_line: line.points = path;
	
	return (path[1] - global_position).normalized();

func shoot():
	if randi() % 3 == 0:
		phi = rand_range(0,PI)
	
	var P = projectile.instance() as Area2D;

	get_tree().current_scene.add_child(P);

	P.global_position = global_position;
	P.modulate = Color.crimson;
	P.collision_mask = 32; # player
	P.speed = proj_speed;
	P.knock_back = proj_knock_back;
	P.dmg = proj_dmg;
	
	P.direction = (get_tree().current_scene.player.global_position + get_tree().current_scene.player.velocity - global_position).normalized();
