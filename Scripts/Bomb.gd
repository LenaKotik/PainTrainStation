extends Sprite

export var projectile : PackedScene;
export var amount : int;
export var dmg : float;
export var knock_back : float;
export var speed : float;
export var proj_speed : float;
export var direction : Vector2;

func _process(delta):
	global_position += direction * speed * delta;

onready var tmr : Timer = $Timer;

func _ready():
	tmr.connect("timeout", self, "explode");

func explode():
	hide();
	var angle = TAU/float(amount);
	for i in range(amount):
		var rot = angle * i;
		var P = projectile.instance() as Area2D;
		get_tree().current_scene.add_child(P);
		P.global_position = global_position;
		P.dmg = dmg;
		P.knock_back = knock_back;
		P.direction = Vector2.RIGHT.rotated(rot);
		P.speed = proj_speed;
	queue_free();
