extends Area2D

export var steer_force : float;
export var speed : float;
export var dmg : float;
export var knock_back : float;

var velocity : Vector2 = Vector2.LEFT;
var target : Player;

func _process(delta):
	if target != null:
		velocity += ((target.global_position - global_position).normalized()*speed - velocity.normalized()*speed).normalized()*steer_force;
	global_position += velocity * delta * speed
	rotation = (-velocity).angle();

func _on_collided(area):
	queue_free()
func _on_life_ended():
	queue_free()
