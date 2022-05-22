extends Throwable

export var throwable : PackedScene;
export var dmg : float;
export var speed : float;


func throw():
	var T = throwable.instance();
	get_tree().current_scene.add_child(T);
	T.global_position = global_position;
	T.direction = get_global_mouse_position() - get_parent().get_parent().global_position;
	T.dmg = dmg;
	T.speed = speed;
	T.knock_back = knock_back;
	get_parent().remove_throwable(self);
