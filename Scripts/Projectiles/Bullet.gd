extends Area2D

export var speed : float;
export var direction : Vector2;
export var dmg : float;
export var knock_back : float;
export var rotation_applied : float;
export var deflectable : bool;

onready var visNot : VisibilityNotifier2D = $VisibilityNotifier2D;
onready var sprite : Sprite = $Bullet1;

func _ready():
	self.connect("area_entered", self, "collided");
	self.connect("body_entered", self, "collided");
	visNot.connect("screen_exited", self, "queue_free");

func _process(delta):
	global_position += speed * delta * direction
	if rotation_applied == 0:
		look_at(global_position+direction);
	else:
		rotation += rotation_applied * delta;

func collided(area : Node):
	if deflectable and "sword" in area.get_groups(): return;
	queue_free();

func set_color(c : Color):
	sprite.self_modulate = c;
