extends KinematicBody2D


onready var sideTrigs = [$left, $right, $up, $down];
onready var ray : RayCast2D = $RayCast2D;
onready var anim : AnimationPlayer = $AnimationPlayer;

var has_player : bool = false;

func _ready():
	for i in range(3):
		(sideTrigs[i] as Area2D).connect("body_entered", self, "side" + str(i) + "_in");
		(sideTrigs[i] as Area2D).connect("body_entered", self, "side" + str(i) + "_out");
func player_in():
	has_player = true;
	anim.play("land");
	for t in sideTrigs:
		(t as Area2D).monitoring = true;
func player_out():
	has_player = false;
	anim.play_backwards("land");
	for t in sideTrigs:
		(t as Area2D).monitoring = false;

func side0_in(body):
	ray.global_position = sideTrigs[0];
	ray.cast_to(Vector2.LEFT*50);
func side1_in(body):
	ray.global_position = sideTrigs[1];
	ray.cast_to(Vector2.RIGHT*50);
func side2_in(body):
	ray.global_position = sideTrigs[2];
	ray.cast_to(Vector2.UP*50);
func side3_in(body):
	ray.global_position = sideTrigs[3];
	ray.cast_to(Vector2.DOWN*50);

func side0_out(body):
	ray.cast_to.x = 0;
func side1_out(body):
	ray.cast_to.x = 0;
func side2_out(body):
	ray.cast_to.y = 0;
func side3_out(body):
	ray.cast_to.y = 0;

func _input(event):
	if event.is_action_pressed("jump") and ray.is_colliding():
		pass # TODO: implement jumping
