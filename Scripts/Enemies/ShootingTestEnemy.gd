extends Enemy

export var use_line : bool;
export var line_color : Color;
export var projectile : PackedScene;
export var death_effect : PackedScene;
export var proj_speed : float;
export var proj_knock_back : float;
export var proj_dmg : float;
export var desired_range : float;

var line : Line2D;
var phi : float = 0;

onready var tmr : Timer = $ShootInterval;
onready var sprite : AnimatedSprite = $AnimatedSprite;

func _ready():
	tmr.connect("timeout", self, "shoot");
	sprite.connect("animation_finished", self, "switch_anim");
	
	if !use_line: return;
	
	line = Line2D.new();
	line.width = 1;
	line.default_color = line_color;
	get_tree().current_scene.call_deferred("add_child",line);
	

func _process(delta):
	move();
	if velocity.x != 0:
		sprite.flip_h = velocity.x > 0;
		rotation_degrees = abs(rotation_degrees) * 1 if velocity.x > 0 else -1;

func on_death():
	if use_line: line.queue_free();
	var E = death_effect.instance();
	get_tree().current_scene.add_child(E);

func get_direction():
	if get_tree().current_scene.player == null: return Vector2.ZERO;
	var pl_pos = get_tree().current_scene.player.global_position;
	
	var actual_range : float = global_position.distance_to(pl_pos);
	
	if (actual_range == desired_range): return Vector2.ZERO;
	var dir : Vector2 = (global_position - pl_pos).normalized().rotated(phi);
	var to : Vector2 = pl_pos + dir * (desired_range);
	
	var path = get_tree().current_scene.nav.get_simple_path(global_position,to);
	
	if use_line: line.points = path;
	
	return (path[1] - global_position).normalized();

func shoot():
	sprite.play("attack");
	if randi() % 3 == 0:
		phi = rand_range(-.5,.5);
	if get_tree().current_scene.player == null:
		return;
	var pl_pos = get_tree().current_scene.player.global_position;
	var pl_vel = get_tree().current_scene.player.velocity;
	var P = projectile.instance() as Area2D;

	get_tree().current_scene.add_child(P);

	P.global_position = global_position;
	P.modulate = Color.crimson;
	P.collision_mask = 32; # player
	P.speed = proj_speed;
	P.knock_back = proj_knock_back;
	P.dmg = proj_dmg;
	
	P.direction = (pl_pos + pl_vel - global_position).normalized();
func switch_anim():
	sprite.play("idle");
