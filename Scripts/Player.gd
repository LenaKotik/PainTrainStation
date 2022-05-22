extends Actor
class_name Player

signal hp_changed(new_hp);
signal ptr_changed(new_ptr);
signal weapon_added(texture);
signal weapon_removed(idx);
signal died;

export var max_hp : float;

onready var sprite : Sprite = $Octopus;
onready var attrs : Array = [$Mouth, $Eyes, $Hat];
onready var invRot : Node2D = $InventoryRotor;
onready var inventory : Node2D = $InventoryRotor/Inventory;
onready var anim : AnimationPlayer = $AnimationPlayer;
onready var HB : Area2D = $HB;
onready var HB_coll : CollisionShape2D = $HB/CollisionShape2D;
onready var phys_coll : CollisionShape2D = $CollisionShape2D;

var hp : float setget set_hp;
var inter : Interactable;

func set_hp(value : float):
	#TODO: implement... stuff
	if hp > value:
		anim.play("hurt");
	hp = max(0, value);
	emit_signal("hp_changed", hp);
	if (hp == 0):
		die();

func die():
	get_parent().player = null;
	emit_signal("died");
	queue_free();

func _ready():
	hp = max_hp;
	HB.connect("area_entered", self, "on_collided");
	inventory.connect("ptr_changed", self, "on_ptr_changed");
	inventory.connect("weapon_removed", self, "on_weapon_removed");
	rand_init();

func on_ptr_changed(new : int):
	emit_signal("ptr_changed", new);
func on_weapon_removed(idx : int):
	emit_signal("weapon_removed", idx);

func set_collision(value : bool):
	HB_coll.disabled = !value;
	phys_coll.disabled = !value;

func rand_init():
	randomize();
	
	var eyes = ["res://Textures/mc/Eyes/1.png", "res://Textures/mc/Eyes/2.png", "res://Textures/mc/Eyes/3.png", "res://Textures/mc/Eyes/4.png"];
	var hats = ["res://Textures/mc/Hat/9.png", "res://Textures/mc/Hat/10.png", "res://Textures/mc/Hat/11.png", "res://Textures/mc/Hat/12.png", "res://Textures/mc/Hat/13.png", "res://Textures/mc/Hat/14.png", "res://Textures/mc/Hat/15.png"];
	var mouths = ["res://Textures/mc/Mouth/3.png", "res://Textures/mc/Mouth/5.png", "res://Textures/mc/Mouth/6.png", "res://Textures/mc/Mouth/7.png", "res://Textures/mc/Mouth/8.png"];
	var colors = [Color.blue, Color.crimson, Color.darkolivegreen, Color.darkorange, Color.darkmagenta, Color.darkcyan, Color.aqua, Color.green];
	for arr in [mouths, eyes, hats, colors]: arr.shuffle()
	
	sprite.modulate = colors.pop_back();
	for i in range(attrs.size()):
		attrs[i].texture = load([mouths, eyes, hats][i].pop_back());

func _process(_delta : float) -> void:
	move();
	
	invRot.look_at(get_global_mouse_position());
	
	if Input.is_action_just_pressed("interact") and inter != null:
		inter.interact(self);
	
	if particles.process_material != null and particles.process_material is ParticlesMaterial:
		particles.process_material.direction.x = abs(particles.process_material.direction.x) * -1 if sprite.flip_h else 1;
	
	if (velocity.x != 0):
		sprite.flip_h = velocity.x < 0;
		for s in attrs:
			s.flip_h = velocity.x < 0;

func add_weapon(w : Weapon):
	emit_signal("weapon_added", w.texture);
	inventory.add_weapon(w);

func on_collided(area : Area2D):
	if "projectile" in area.get_groups():
		set_hp(hp - area.dmg);
		velocity += (global_position - area.global_position).normalized() * area.knock_back;
	
	else: if area.get_parent() is Enemy:
		set_hp(hp - area.get_parent().dmg);
		velocity += (global_position - area.global_position).normalized() * area.get_parent().knock_back;

func get_direction():
	return Vector2(
		Input.get_action_strength("right")-Input.get_action_strength("left"),
		Input.get_action_strength("down")-Input.get_action_strength("up")).normalized();
