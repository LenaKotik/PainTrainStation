extends Enemy

export var proj : PackedScene;
export var desired_range : float;
export var shoot_period : int;
export var proj_amount : int;
export var proj_dmg : float;
export var min_jump_d : float;
export var max_jump_d : float;
export var jump_distance : float;
export var anim_height : float;

onready var sprite : Sprite = $Will_you_bee_mine;
onready var shoot_cd : Timer = $shoot_cd;
onready var shoot_delay : Timer = $shoot_delay;
onready var anim_tmr : Timer = $anim_tmr;

var shootPos : Vector2 = Vector2(-16, 7);
var anim_start : Vector2;
var anim_mid : Vector2;
var anim_end : Vector2;
var is_shooting : bool

func _ready():
	anim_tmr.connect("timeout", self, "anim_ended");
func anim_ended():
	can_move = true;
func _process(delta):
	if !anim_tmr.is_stopped():
		var t = 1-(anim_tmr.time_left / anim_tmr.wait_time);
		if t <= 0.5:
			global_position = anim_start.cubic_interpolate(anim_mid, Vector2(anim_mid.x, anim_start.y), anim_end, t*2);
		else:
			global_position = anim_mid.cubic_interpolate(anim_end, anim_start, Vector2(anim_mid.x, anim_start.y), t*2-1);
		return;
	move();
	if velocity.x != 0:
		sprite.flip_h = velocity.x > 0;
		shootPos.x = abs(shootPos.x) * sign(velocity.x);
	if shoot_cd.is_stopped() and randi() % (shoot_period*60) == 0:
		shoot();
func get_direction() -> Vector2:
	if is_shooting: return Vector2.ZERO;
	if get_tree().current_scene.player == null: return Vector2.ZERO;
	var pl = get_tree().current_scene.player as Player;
	var des : Vector2;
	if (shoot_cd.time_left / shoot_cd.wait_time) >= 0.5:
		des = pl.global_position;
	else:
		des = pl.global_position + (global_position - pl.global_position).rotated(rand_range(-PI/2, PI/2)) * rand_range(global_position.distance_to(pl.global_position), desired_range);
	var path : PoolVector2Array = get_tree().current_scene.get_simple_path(global_position, des, is_air);
	if path.size() == 0: 
		jump(pl);
		return Vector2.ZERO;
	return path[1] - global_position;

func jump(pl : Player):
	print("jumping!")
	for i in range(10):
		var des = pl.global_position + pl.global_position + (global_position - pl.global_position).rotated(rand_range(-PI/2, PI/2)) * rand_range(min_jump_d, max_jump_d);
		if global_position.distance_squared_to(des) > jump_distance*jump_distance:continue
		if get_tree().current_scene.get_simple_path(des, pl.global_position).size() == 0: continue;
		
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
		P.target = get_tree().current_scene.player;
	shoot_cd.start();
