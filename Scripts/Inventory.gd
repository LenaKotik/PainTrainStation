extends Node2D

var ptr : int = 0;

onready var tmr : Timer = get_parent().get_node("Timer");

func add_weapon(w : Weapon):
	add_child(w);
	w.global_position = global_position;
	w.visible = false;
func _process(_delta):
	if get_child_count() == 0:
		return;
	
	for i in range(1, 3):
		if (Input.is_action_pressed("num"+String(i))):
			ptr = i-1;
	
	if (Input.is_action_just_pressed("next_w") or Input.is_action_just_pressed("prev_w")):
		tmr.start();
	
	if tmr.is_stopped():
		ptr += Input.get_action_strength("next_w") - Input.get_action_strength("prev_w");
	ptr = clamp(ptr, 0, get_child_count()-1);
	
	for i in range(get_child_count()):
		get_children()[i].visible = (i == ptr);
	var current : Weapon = get_children()[ptr] as Weapon;
	
	current.flip_v = get_global_mouse_position().x < get_parent().global_position.x;
	
	if (current.auto and Input.is_action_pressed("attack")) or (Input.is_action_just_pressed("attack")):
		if current is Gun:
			current.shoot();
		else: if current is Melee:
			current.swing();
