extends Interactable;

export var throwable : PackedScene;
export var amount : int;

func interact(a : Actor):
	if a is Player:
		a.add_throwable(throwable.instance() as Throwable, amount);
		queue_free();
