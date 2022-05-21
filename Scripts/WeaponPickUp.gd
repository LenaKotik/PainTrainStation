extends Interactable

signal taken;

export(PackedScene) var weapon : PackedScene;

func interact(body:Actor):
	if body is Player:
		var W = weapon.instance();
		body.add_weapon(W);
		# TODO: effets here
		emit_signal("taken");
		queue_free();
