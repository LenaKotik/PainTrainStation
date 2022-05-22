extends Area2D

export var steer_force : float;
export var speed : float;
export var dmg : float;
export var knock_back : float;

onready var sprite : AnimatedSprite = $AnimatedSprite;
onready var particles : CPUParticles2D = $CPUParticles2D;
onready var coll : CollisionShape2D = $CollisionShape2D;
onready var delay : Timer = $death_delay;

var velocity : Vector2 = Vector2.LEFT;
var target : WeakRef;

func _process(delta):
	if target.get_ref():
		velocity += ((target.get_ref().global_position - global_position).normalized()*speed - velocity.normalized()*speed).normalized()*steer_force;
	global_position += velocity * delta * speed
	rotation = (-velocity).angle();

func _on_collided(area : Area2D):
	if !("sword" in area.get_groups()):
		die();
func _on_life_ended():
	die();

func die():
	coll.set_deferred("disabled", true);
	sprite.hide();
	particles.emitting = false;
	delay.start();
	yield(delay, "timeout");
	queue_free();
