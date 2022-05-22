extends Node2D

signal ptr_changed(new_ptr);
signal weapon_removed()

onready var tmr : Timer = get_parent().get_node("Timer");

var ptr : int = 0 setget set_ptr;

func set_ptr(v : int):
	if v == ptr: return;
	ptr = clamp(v, 0, get_child_count()-1);
	emit_signal("ptr_changed", ptr);

func add_weapon(w : Weapon):
	add_child(w);
	w.global_position = global_position;
	w.visible = false;
	set_ptr(get_child_count()-1);
func remove_weapon(w : Weapon):
	emit_signal("weapon_removed", get_children().find(w));
	remove_child(w);

func _process(_delta):
	if get_child_count() == 0:
		return;
	for i in range(1, 5):
		if (Input.is_action_pressed("num"+String(i))):
			set_ptr(i-1);
	if tmr.is_stopped():
		set_ptr(ptr + Input.get_action_strength("next_weapon") - Input.get_action_strength("prev_weapon"));
		tmr.start();
	
	for i in range(get_child_count()):
		get_children()[i].visible = (i == ptr);
	var current : Weapon = get_children()[ptr] as Weapon;
	
	current.flip_v = get_global_mouse_position().x < get_parent().global_position.x;
	
	if (current.auto and Input.is_action_pressed("attack")) or (Input.is_action_just_pressed("attack")):
		if current is Gun:
			current.shoot();
		else: if current is Melee:
			current.swing();
