extends KinematicBody2D
class_name Player

export var speed : float;
export var friction : float;
export var max_hp : float;

onready var sprite : Sprite = $GrayCat;
onready var particles : Particles2D = $FeetParticles;
onready var invRot : Node2D = $InventoryRotor;
onready var inventory : Node2D = $InventoryRotor/Inventory;

var hp : float = max_hp setget set_hp;
var velocity : Vector2 = Vector2.ZERO;
var inter : Interactable;
var can_move : bool = true;

func set_hp(value : float):
	#TODO: implement... stuff
	hp = max(0, value);

func _process(_delta : float) -> void:
	var input : Vector2 = Vector2(
		Input.get_action_strength("right")-Input.get_action_strength("left"),
		Input.get_action_strength("down")-Input.get_action_strength("up")).normalized();
	invRot.look_at(get_global_mouse_position());
	if Input.is_action_just_pressed("interact") and inter != null:
		inter.interact(self);
	if particles.process_material != null and particles.process_material is ParticlesMaterial:
		particles.process_material.direction.x = abs(particles.process_material.direction.x) * -1 if sprite.flip_h else 1;
	velocity += input*speed*int(can_move);
	velocity = lerp(velocity, Vector2.ZERO, friction);
	if (velocity.x != 0):
		sprite.flip_h = velocity.x > 0;
# warning-ignore:return_value_discarded
	move_and_slide(velocity, Vector2.ZERO);
func add_weapon(w : Weapon):
	inventory.add_weapon(w);
