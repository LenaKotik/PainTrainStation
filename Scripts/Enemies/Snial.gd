extends Enemy

export var proj : PackedScene;
#export var desired_range : float;
export var jump_period : int;
export var shoot_period : int;
export var proj_amount : int;
export var proj_dmg : float;
export var min_jump_d : float;
export var max_jump_d : float;
export var use_line : bool;
export var line_color : Color;
export var jump_distance : float;
export var anim_height : float;

onready var sprite : Sprite = $Will_you_bee_mine;
onready var shoot_cd : Timer = $shoot_cd;
onready var shoot_delay : Timer = $shoot_delay;
onready var anim_tmr : Timer = $anim_tmr;
onready var HB_coll : CollisionShape2D = $HB/CollisionShape2D;
onready var HP_rot : Node2D = $HP_rotor;

var shootPos : Vector2 = Vector2(-16, 7);
var anim_start : Vector2;
var anim_mid : Vector2;
var anim_end : Vector2;
var is_shooting : bool
var line : Line2D;

func _ready():
	anim_tmr.connect("timeout", self, "anim_ended");
	if !use_line: return;
	line = Line2D.new();
	line.width = 1;
	line.default_color = line_color;
	get_tree().current_scene.call_deferred("add_child",line);

func anim_ended():
	HB_coll.disabled = false;
	can_move = true;
	rotation = 0;
	HP_rot.rotation = 0
func _process(delta):
	if !anim_tmr.is_stopped():
		var t = 1-(anim_tmr.time_left / anim_tmr.wait_time);
		rotation = TAU*lerp_angle(0, (TAU-1) * sign(anim_end.x-anim_start.x+1), t);
		HP_rot.rotation = -TAU*lerp_angle(0, (TAU-1) * sign(anim_end.x-anim_start.x+1), t);
		if t <= 0.5:
			global_position = anim_start.cubic_interpolate(anim_mid, Vector2(anim_mid.x, anim_start.y), anim_end, t*2);
		else:
			global_position = anim_mid.cubic_interpolate(anim_end, anim_start, Vector2(anim_mid.x, anim_start.y), t*2-1);
		return;
	move();
	if velocity.x != 0:
		sprite.flip_h = velocity.x > 0;
		shootPos.x = abs(shootPos.x) * sign(velocity.x);
	if get_tree().current_scene.player != null and anim_tmr.is_stopped() and randi() % (jump_period*60) == 0:
		jump(get_tree().current_scene.player);
	if shoot_cd.is_stopped() and randi() % (shoot_period*60) == 0:
		shoot();
func get_direction() -> Vector2:
	if is_shooting: return Vector2.ZERO;
	if get_tree().current_scene.player == null: return Vector2.ZERO;
	var pl = get_tree().current_scene.player as Player;
	var des : Vector2;
	des = pl.global_position;
	var path : PoolVector2Array = get_tree().current_scene.get_simple_path(global_position, des, is_air);
	if path.size() == 0: 
		jump(pl);
		return Vector2.ZERO;
	return (path[1] - global_position).normalized();

func jump(pl : Player):
	var des = pl.global_position + (global_position - pl.global_position).normalized().rotated(rand_range(-PI/2, PI/2)) * rand_range(min_jump_d, max_jump_d);
	if global_position.distance_squared_to(des) > jump_distance*jump_distance:
		return;
	if get_tree().current_scene.get_closest_point(des, is_air) != des: 
		return;
	
	HB_coll.disabled = true;
	can_move = false;
	anim_tmr.start();
	anim_start = global_position;
	anim_end = des;
	anim_mid = global_position + Vector2((anim_end-anim_start).x/2, (anim_end-anim_start).y+anim_height*-1);

func shoot():
	is_shooting = true;
	for i in range(proj_amount):
		shoot_delay.start();
		yield(shoot_delay, "timeout");
		var P = proj.instance() as Area2D;
		get_tree().current_scene.add_child(P);
		P.global_position = global_position + shootPos;
		P.dmg = proj_dmg;
		P.target = weakref(get_tree().current_scene.player);
	shoot_cd.start();
	is_shooting = false;
