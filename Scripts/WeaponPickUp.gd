extends Interactable

export(PackedScene) var weapon : PackedScene;

func interact(body:Actor):
	if body is Player:
		var W = weapon.instance();
		body.add_weapon(W);
		# TODO: effets here
		queue_free();
