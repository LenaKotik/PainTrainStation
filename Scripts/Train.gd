extends KinematicBody2D
class_name Train

export var anim_height : float;
export var nodes_to_animate : PoolStringArray;

onready var sideTrigs = [$left, $right, $up, $down];
onready var ray : RayCast2D = $RayCast2D;
onready var anim : AnimationPlayer = $AnimationPlayer;
onready var anim_tmr = $Timer;

var has_player : bool = false;
var anim_start : Vector2;
var anim_end : Vector2;
var anim_mid : Vector2;
var target : Train;

func _ready():
	for i in range(4):
		(sideTrigs[i] as Area2D).connect("body_entered", self, "side" + str(i) + "_in");
		(sideTrigs[i] as Area2D).connect("body_exited", self, "side" + str(i) + "_out");
	anim_tmr.connect("timeout", self, "anim_ended");
func player_in():
	has_player = true;
	anim.play("land");
	for t in sideTrigs:
		(t as Area2D).monitoring = true;
	for np in nodes_to_animate:
		var n = get_node_or_null(np);
		if n == null: continue;
		n.position.y += 5;
func player_out():
	has_player = false;
	anim.play_backwards("land");
	for t in sideTrigs:
		(t as Area2D).monitoring = false;
	for np in nodes_to_animate:
		var n = get_node_or_null(np);
		if n == null: continue;
		n.position.y -= 5;

func side0_in(body):
	ray.global_position = sideTrigs[0].global_position;
	ray.cast_to = Vector2.LEFT*150;
func side1_in(body):
	ray.global_position = sideTrigs[1].global_position;
	ray.cast_to = Vector2.RIGHT*150;
func side2_in(body):
	ray.global_position = sideTrigs[2].global_position;
	ray.cast_to = Vector2.UP*150;
func side3_in(body):
	ray.global_position = sideTrigs[3].global_position;
	ray.cast_to = Vector2.DOWN*150;
func side0_out(body):
	ray.cast_to.x = 0;
func side1_out(body):
	ray.cast_to.x = 0;
func side2_out(body):
	ray.cast_to.y = 0;
func side3_out(body):
	ray.cast_to.y = 0;
func _process(delta):
	if anim_tmr.is_stopped(): return;
	if get_tree().current_scene.player == null: return;
	var pl = get_tree().current_scene.player as Player;
	var t = 1-(anim_tmr.time_left / anim_tmr.wait_time);
	pl.rotation = TAU*lerp_angle(0, (TAU-1) * sign(anim_end.x-anim_start.x+1), t);
	if t <= 0.5:
		pl.global_position = anim_start.cubic_interpolate(anim_mid, Vector2(anim_mid.x, anim_start.y), anim_end, t*2);
	else:
		pl.global_position = anim_mid.cubic_interpolate(anim_end, anim_start, Vector2(anim_mid.x, anim_start.y), t*2-1);
func anim_ended():
	if get_tree().current_scene.player == null: return;
	var pl = get_tree().current_scene.player as Player;
	pl.set_collision(true);
	pl.rotation = 0;
	if target != null:
		target.player_in();

func _input(event):
	if event.is_action_pressed("jump") and ray.is_colliding():
		if get_tree().current_scene.player == null: return;
		var pl = get_tree().current_scene.player as Player;
		target = ray.get_collider();
		anim_start = pl.global_position;
		anim_end = pl.global_position + ray.cast_to;
		anim_mid = pl.global_position + Vector2(ray.cast_to.x/2, ray.cast_to.y+anim_height*-1);
		pl.set_collision(false);
		anim_tmr.start();
		player_out();
