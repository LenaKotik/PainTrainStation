extends Gun

export var throwable : PackedScene;
export var dmg : float;
export var speed : float;

var amount : int = 1;

func shoot():
	var T = throwable.instance();
	get_tree().current_scene.add_child(T);
	T.global_position = global_position;
	T.direction = get_global_mouse_position() - get_parent().get_parent().global_position;
	T.dmg = dmg;
	T.speed = speed;
	T.knock_back = knock_back;
	amount -= 1;
	if amount == 0: get_parent().remove_weapon(self);
