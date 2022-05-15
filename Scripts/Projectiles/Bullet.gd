extends Area2D

export var speed : float;
export var direction : Vector2;

func _ready():
	self.connect("area_entered", self, "collided");

func _process(delta):
	global_position += speed * delta * direction
	look_at(global_position+direction);

func collided(_area : Area2D):
	queue_free();
