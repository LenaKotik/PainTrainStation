extends Weapon
class_name Melee

var is_up : bool;

onready var HB_coll : CollisionShape2D = $HurtBox/CollisionShape2D;
onready var HB : Area2D = $HurtBox;
onready var anim_tmr : Timer = $Timer;

var start_rot : float;
var end_rot : float;
var can_swing : bool = false;

func _ready():
	anim_tmr.connect("timeout", self, "anim_end");
	HB.connect("area_entered", self, "collided");

func collided(_area : Area2D):
	HB_coll.set_deferred("disabled", true);

func anim_end():
	rotation = end_rot;
	can_swing = true;
	HB_coll.disabled = true;
	is_up = !is_up;

func swing():
	if !can_swing: return;
	can_swing = false;
	HB_coll.disabled = false;
	if is_up:
		start_rot = -PI/2;
		end_rot = PI/2;
	else:
		start_rot = PI/2;
		end_rot = -PI/2;
	anim_tmr.start();

func _process(delta):
	if anim_tmr.is_stopped(): return;
	print("swong indeed");
	rotation = lerp(start_rot, end_rot, 1-(anim_tmr.time_left/anim_tmr.wait_time));
