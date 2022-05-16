extends Area2D

export var speed : float;
export var direction : Vector2;
export var dmg : float;
export var knock_back : float;

onready var visNot : VisibilityNotifier2D = $VisibilityNotifier2D;

func _ready():
	self.connect("area_entered", self, "collided");
	self.connect("body_entered", self, "collided");
	visNot.connect("screen_exited", self, "queue_free");

func _process(delta):
	global_position += speed * delta * direction
	look_at(global_position+direction);

func collided(_area : Node):
	queue_free();
